import ballerinax/twilio;
import ballerina/sql;

configurable boolean enableSmsNotification = ?;

type TwilioConfig record {|
    string accountSid;
    string authToken;
    string messageSenderId;
|};
configurable TwilioConfig twilioConfig = ?;

final twilio:Client twilioClient = check new ({
    twilioAuth: {
        accountSId: twilioConfig.accountSid,
        authToken: twilioConfig.authToken
    }
});

type FollowerInfo record {|
    @sql:Column {name: "mobile_number"} 
    string mobileNumber;
|};

function sendSmsToFollowers(User leader) returns error? {
    if !enableSmsNotification {
        return;
    }
    stream<FollowerInfo, sql:Error?> followersStream = socialMediaDb->query(`
            SELECT mobile_number 
            FROM users JOIN followers ON users.id = followers.follower_id
            WHERE followers.leader_id = ${leader.id};`);
    string[] mobileNumbers = check from var follower in followersStream select follower.mobileNumber;
    foreach string mobileNumber in mobileNumbers {
        string message = string `User ${leader.id} has a new post.`;
        _ = check twilioClient->sendSms(twilioConfig.messageSenderId, mobileNumber, message);
    }
}
