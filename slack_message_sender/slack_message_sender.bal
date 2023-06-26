import ballerina/log;
import ballerinax/nats;
import ballerinax/slack;

configurable string natsUrl = ?;

type SlackConfig record {|
    string authToken;
    string channelName;
|};
configurable SlackConfig slackConfig = ?;
final slack:Client slackClient = check new({
    auth: {
        token: slackConfig.authToken
    }
});

type NotificationEvent record {|
    int leaderId;
|};

service "ballerina.social.media" on new nats:Listener(natsUrl) {
    public function init() returns error? {
        log:printInfo("Slack message sender service started");
    }

    remote function onMessage(NotificationEvent event) returns error? {
        check sendSlackMessage(event);
    }
}

function sendSlackMessage(NotificationEvent event) returns error? {
    slack:Message message = {
        channelName: slackConfig.channelName,
        text: string `User ${event.leaderId} has a new post.`
    };
    _ = check slackClient->postMessage(message);
}
