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

import ballerina/http;
import ballerina/websubhub;
import ballerina/log;
import ballerina/io;
import xlibb/pubsub;

final pubsub:PubSub pubsub = new (autoCreateTopics = true);

const HUB_TOPIC = "follower-notifications";

service /hub on new websubhub:Listener(9091) {

    public function init() returns error? {
        log:printInfo("Notification Hub started");
    }

    // Topic registration is not supported by this `hub`
    remote function onRegisterTopic(readonly & websubhub:TopicRegistration message)
        returns websubhub:TopicRegistrationError {
        return error websubhub:TopicRegistrationError(
            "Topic registration is not supported", statusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Topic deregistration is not supported by this `hub`
    remote function onDeregisterTopic(readonly & websubhub:TopicDeregistration message)
        returns websubhub:TopicDeregistrationError {
        return error websubhub:TopicDeregistrationError(
            "Topic deregistration is not supported", statusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    # Publishes a new update to a topic.
    # 
    # + message - Content update message
    # + return - `websubhub:UpdateMessageError` is there is an error or else `websubhub:Acknowledgement`
    remote function onUpdateMessage(readonly & websubhub:UpdateMessage message) 
        returns websubhub:Acknowledgement|websubhub:UpdateMessageError {
        io:println(message);
        if HUB_TOPIC != message.hubTopic {
            return error websubhub:UpdateMessageError(
                string `Topic ${message.hubTopic} not found`, statusCode = http:STATUS_NOT_FOUND);
        }
        pubsub:Error? result = pubsub.publish(message.hubTopic, message);
        if result is pubsub:Error {
            string errorMsg = string `Content publish failed: ${result.message()}`;
            log:printError(errorMsg, stackTrace = result.stackTrace());
            return error websubhub:UpdateMessageError(
                string `Content publish failed: ${result.message()}`, statusCode = http:STATUS_INTERNAL_SERVER_ERROR);
        }
        return websubhub:ACKNOWLEDGEMENT;
    }

    # Validates a incomming subscription request.
    #
    # + subscription - Details of the subscription
    # + return - `websubhub:SubscriptionDeniedError` if the subscription is denied by the hub or else `()`
    remote function onSubscriptionValidation(readonly & websubhub:Subscription subscription)
        returns websubhub:SubscriptionDeniedError? {
        if HUB_TOPIC != subscription.hubTopic {
            return error websubhub:SubscriptionDeniedError(
                string `Topic ${subscription.hubTopic} not found`, statusCode = http:STATUS_NOT_FOUND);
        }
        string subscriptionId = string `${subscription.hubTopic}-${subscription.hubCallback}`;
        if subscriptionAvailable(subscriptionId) {
            return error websubhub:SubscriptionDeniedError(
                string `Subscription for topic ${subscription.hubTopic} and callback ${subscription.hubCallback} already exists`,
                statusCode = http:STATUS_CONFLICT);
        }
    }

    # Processes a verified subscription request.
    #
    # + subscription - Details of the subscription
    # + return - `error` if there is any unexpected error or else `()`
    remote function onSubscriptionIntentVerified(readonly & websubhub:VerifiedSubscription subscription) returns error? {
        addSubscription(subscription);
        _ = start dispatchContent(subscription);
    }

    # Validates a incomming unsubscription request.
    #
    # + unsubscription - Details of the unsubscription
    # + return - `websubhub:UnsubscriptionDeniedError` if the unsubscription is denied by the hub or else `()`
    remote function onUnsubscriptionValidation(readonly & websubhub:Unsubscription unsubscription)
        returns websubhub:UnsubscriptionDeniedError? {
        if HUB_TOPIC != unsubscription.hubTopic {
            return error websubhub:UnsubscriptionDeniedError(
                string `Topic ${unsubscription.hubTopic} not found`, statusCode = http:STATUS_NOT_FOUND);
        }
        string subscriptionId = string `${unsubscription.hubTopic}-${unsubscription.hubCallback}`;
        if !subscriptionAvailable(subscriptionId) {
            return error websubhub:UnsubscriptionDeniedError(
                string `Subscription for topic ${unsubscription.hubTopic} and callback ${unsubscription.hubCallback} not found`,
                statusCode = http:STATUS_NOT_FOUND);
        }
    }

    # Processes a verified unsubscription request.
    #
    # + unsubscription - Details of the unsubscription
    # + return - `error` if there is any unexpected error or else `()`
    remote function onUnsubscriptionIntentVerified(readonly & websubhub:VerifiedUnsubscription unsubscription) returns error? {
        removeSubscription(unsubscription);
    }
}
