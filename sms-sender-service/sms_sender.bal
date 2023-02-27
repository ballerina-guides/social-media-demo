import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/sql;
import ballerinax/twilio;
import ballerina/log;
import ballerinax/nats;
import ballerinax/jaeger as _;

configurable string natsUrl = ?;

type DataBaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};
configurable DataBaseConfig databaseConfig = ?;
final mysql:Client socialMediaDb = check new (...databaseConfig);

type TwilioConfig record {|
    string accountSid;
    string authToken;
    string messageSenderId;
|};
configurable TwilioConfig twilioConfig = ?;
final twilio:Client twilioClient = check new (config = {
    twilioAuth: {
        accountSId: twilioConfig.accountSid,
        authToken: twilioConfig.authToken
    }
});

service "ballerina.social.media" on new nats:Listener(natsUrl) {
    public function init() returns error? {
        log:printInfo("SMS sender service started");
    }

    remote function onMessage(int leaderId) returns error? {
        check sendSms(leaderId);
    }
}

type FollowerInfo record {|
    @sql:Column {name: "mobile_number"} 
    string mobileNumber;
|};

function sendSms(int leaderId) returns error? {
    stream<FollowerInfo, sql:Error?> followersStream = socialMediaDb->query(`
            SELECT mobile_number 
            FROM users JOIN followers ON users.id = followers.follower_id
            WHERE followers.leader_id = ${leaderId};`);
    string[] mobileNumbers = check from var follower in followersStream select follower.mobileNumber;
    foreach string mobileNumber in mobileNumbers {
        string message = string `User ${leaderId} has a new post.`;
        _ = check twilioClient->sendSms(twilioConfig.messageSenderId, mobileNumber, message);
    }
}
