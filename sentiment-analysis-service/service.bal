import ballerina/http;
import ballerinax/jaeger as _;
import ballerina/log;

listener http:Listener sentiment_ls = new (9099, {
    secureSocket: {
        key: {
            certFile: "./resources/public.crt",
            keyFile: "./resources/private.key"
        }
    }
});

@http:ServiceConfig {
    auth: [
        {
            oauth2IntrospectionConfig: {
                url: "https://localhost:9445/oauth2/introspect",
                tokenTypeHint: "access_token",
                clientConfig: {
                    customHeaders: {"Authorization": "Basic YWRtaW46YWRtaW4="},
                    secureSocket: {
                        cert: "./resources/public.crt"
                    }
                }
            }
        }
    ]
}
service /text\-processing on sentiment_ls {

    public function init() {
        log:printInfo("Sentiment analysis service started");
    }

    resource function post api/sentiment(@http:Payload Post post) returns Sentiment {
        return {
            "probability": { 
                "neg": 0.30135019761690551, 
                "neutral": 0.27119050546800266, 
                "pos": 0.69864980238309449
            }, 
            "label": "pos"
        };
    }
}

type Probability record {
    decimal neg;
    decimal neutral;
    decimal pos;
};

type Sentiment record {
    Probability probability;
    string label;
};

type Post record {
    string text;
};

