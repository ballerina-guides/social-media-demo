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

import ballerinax/mysql;
import ballerinax/nats;
import balguides/sentiment.analysis;

type DataBaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};
configurable DataBaseConfig databaseConfig = ?;
final mysql:Client socialMediaDb = check initDbClient();
function initDbClient() returns mysql:Client|error => new (...databaseConfig);

type SentimentEndpointConfig record {|
    string endpointUrl;
    decimal retryInterval;
    record {|
        string refreshUrl;
        string clientId;
        string clientSecret;
        string refreshToken;
    |} authConfig;
|};
configurable SentimentEndpointConfig sentimentEndpointSecConfig = ?;
final analysis:Client sentimentEndpoint = check new (serviceUrl = sentimentEndpointSecConfig.endpointUrl,
    config = {
        retryConfig: {
            interval: sentimentEndpointSecConfig.retryInterval
        },
        auth: {
            ...sentimentEndpointSecConfig.authConfig,
            clientConfig: {
                secureSocket: {
                    cert: "./resources/public.crt"
                }
            }
        },
        secureSocket: {
            cert: "./resources/public.crt"
        }
    }
);

type NatsConfig record {|
    record {|
        int maxReconnect;
        decimal reconnectWait;
        decimal connectionTimeout;
    |} retryConfig;
    string url;
|};
configurable NatsConfig natsConfig = ?;
final nats:Client natsClient = check new (natsConfig.url, 
    retryConfig = {
        ...natsConfig.retryConfig
    }
);
