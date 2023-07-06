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

import ballerina/websubhub;
import ballerina/mime;
import ballerina/log;

isolated map<websubhub:VerifiedSubscription> subscriptions = {};

isolated function addSubscription(readonly & websubhub:VerifiedSubscription subscription) {
    string subscriptionId = string `${subscription.hubTopic}-${subscription.hubCallback}`;
    lock {
        subscriptions[subscriptionId] = subscription;
    }
}

isolated function removeSubscription(readonly & websubhub:VerifiedUnsubscription|string unsubscription) {
    if unsubscription is string {
        lock {
            _ = subscriptions.removeIfHasKey(unsubscription);
        }
        return;
    }
    string subscriptionId = string `${unsubscription.hubTopic}-${unsubscription.hubCallback}`;
    lock {
        _ = subscriptions.removeIfHasKey(subscriptionId);
    }
}

isolated function subscriptionAvailable(string subscriptionId) returns boolean {
    lock {
        return subscriptions.hasKey(subscriptionId);
    }
}

configurable decimal CLIENT_RETRY_INTERVAL = 3;
configurable int CLIENT_RETRY_COUNT = 3;
configurable decimal CLIENT_TIMEOUT = 10;

function dispatchContent(websubhub:VerifiedSubscription subscriber) returns error? {
    websubhub:HubClient hubClient = check new (subscriber, {
        retryConfig: {
            interval: CLIENT_RETRY_INTERVAL,
            count: CLIENT_RETRY_COUNT,
            backOffFactor: 2.0,
            maxWaitInterval: 20
        },
        timeout: CLIENT_TIMEOUT
    });
    string receiverId = string `${subscriber.hubTopic}-${subscriber.hubCallback}`;
    do {
        stream<websubhub:UpdateMessage, error?> eventStream = check pubsub.subscribe(
            subscriber.hubTopic, timeout = -1);
        while true {
            if !subscriptionAvailable(receiverId) {
                fail error(string `Subscriber with Id ${receiverId} or topic ${subscriber.hubTopic} is invalid`);
            }
            record {|websubhub:UpdateMessage value;|}? event = check eventStream.next();
            if event is record {|websubhub:UpdateMessage value;|} {
                json payload = check event.value.content.ensureType();
                check notifySubscribers(hubClient, check payload.fromJsonWithType());
            }
        }
    } on fail error err {
        log:printError(
            string `Error occurred while sending notification to the subscriber ${receiverId}: ${err.message()}`, 
            stackTrace = err.stackTrace());
        removeSubscription(receiverId);
    }
}

isolated function notifySubscribers(websubhub:HubClient clientEp, record {} content) returns error? {
    websubhub:ContentDistributionMessage message = {
        content: content.toJson(),
        contentType: mime:APPLICATION_JSON
    };
    websubhub:ContentDistributionSuccess|error response = clientEp->notifyContentDistribution(message);
    if response is error {
        return response;
    }
}
