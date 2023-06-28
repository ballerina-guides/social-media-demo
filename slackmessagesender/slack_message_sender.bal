// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

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
