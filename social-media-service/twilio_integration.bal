import ballerinax/twilio;

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
    // TODO: find a way to properly get the followers
    // TODO: find a way to include mobile number into user information
    User[] followers = [];
    foreach User follower in followers {
        _ = check twilioClient->sendSms(messageSenderId, follower.mobileNumber, post.description);
    }
}
