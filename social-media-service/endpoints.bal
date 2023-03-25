import ballerinax/mysql;
import ballerina/http;
import ballerinax/nats;

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
final http:Client sentimentEndpoint = check new (sentimentEndpointSecConfig.endpointUrl,
    retryConfig = {
        interval: sentimentEndpointSecConfig.retryInterval
    },
    auth = {
        ...sentimentEndpointSecConfig.authConfig,
        clientConfig: {
            secureSocket: {
                cert: "./resources/public.crt"
            }
        }
    },
    secureSocket = {
        cert: "./resources/public.crt"
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