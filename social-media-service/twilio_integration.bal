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
    stream<User, sql:Error?> followersStream = socialMediaDb->query(`SELECT u.id, u.name, u.birth_date, u.mobile_number FROM 
            users u INNER JOIN followers f ON u.id=f.follower_id
            WHERE f.leader_id = ${leader.id};`);
    User[] followers = check from User user in followersStream select user;
    foreach User follower in followers {
        _ = check twilioClient->sendSms(messageSenderId, follower.mobileNumber, post.description);
    }
}
