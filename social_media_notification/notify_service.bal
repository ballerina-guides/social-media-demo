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
import ballerina/websocket;

isolated map<websocket:Caller> clients = {};

service /notify on new websocket:Listener(10001) {

    resource function get [int userId]() returns websocket:Service {
        return new NotifyService(userId);
    }
}

service class NotifyService {
    *websocket:Service;
    private final int userId;

    function init(int userId) {
        log:printInfo(string `Initialized a new connection for user: ${userId}`);
        self.userId = userId;
    }

    remote function onOpen(websocket:Caller caller) returns websocket:Error? {
        string clientKey = string `${caller.getConnectionId()}_${self.userId}`;
        lock {
            clients[clientKey] = caller;
        }
    }

    remote function onClose(websocket:Caller caller) {
        string clientKey = string `${caller.getConnectionId()}_${self.userId}`;
        lock {
            _ = clients.removeIfHasKey(clientKey);
        }
    }    
}

isolated function broadcast(readonly & NotificationEvent notification) {
    lock {
        log:printInfo("Received", notification = notification.toBalString(), clients = clients.keys());
        string[] relevantClientsKeys = clients.keys()
            .filter('key => 'key.endsWith(string `_${notification.userId}`));
 
        if relevantClientsKeys.length() == 0 {
            return;
        }
    
        log:printInfo("valid receivers", valid = relevantClientsKeys);
        string message = string `User: ${notification.followerId} has followed you.`;
        
        foreach string clientKey in relevantClientsKeys {
            websocket:Caller caller = clients.get(clientKey);
            websocket:Error? result = caller->writeTextMessage(message);
            if result is websocket:Error {
                log:printError("Error occurred while delivering content to client", 
                    connection = caller.getConnectionId(), stackTrace = result.stackTrace());
            }
        }
    }
}
