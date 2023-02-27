import ballerinax/twilio;
import ballerina/log;
import ballerinax/nats;
import ballerinax/jaeger as _;

configurable string natsUrl = ?;

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

type SmsSendEvent record {|
    int leaderId;
    string[] followerNumbers;
|};

service "ballerina.social.media" on new nats:Listener(natsUrl) {
    public function init() returns error? {
        log:printInfo("SMS sender service started");
    }

    remote function onMessage(SmsSendEvent event) returns error? {
        check sendSms(event);
    }
}

function sendSms(SmsSendEvent event) returns error? {
    foreach string mobileNumber in event.followerNumbers {
        string message = string `User ${event.leaderId} has a new post.`;
        _ = check twilioClient->sendSms(twilioConfig.messageSenderId, mobileNumber, message);
    }
}
