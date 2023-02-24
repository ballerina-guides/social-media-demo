import ballerinax/twilio;
import ballerina/sql;

configurable boolean enableSmsNotification = ?;
configurable string accountSId = ?;
configurable string authToken = ?;
configurable string messageSenderId = ?;

twilio:ConnectionConfig twilioConfig = {
    twilioAuth: {
        accountSId: accountSId,
        authToken: authToken
    }
};

final twilio:Client twilioClient = check new (twilioConfig);

function sendSmsToFollowers(User leader, NewPost post) returns error? {
    if !enableSmsNotification {
        return;
    }
    stream<record {| string mobileNumer; |}, sql:Error?> followersStream = socialMediaDb->query(`
            SELECT mobile_number 
            FROM 
            users JOIN followers ON users.id = followers.follower_id
            WHERE followers.leader_id = ${leader.id};`);
    string[] mobileNumbers = check from record {| string mobileNumer; |} follower in followersStream select follower.mobileNumer;
    foreach string mobileNumber in mobileNumbers {
        _ = check twilioClient->sendSms(messageSenderId, mobileNumber, post.description);
    }
}
