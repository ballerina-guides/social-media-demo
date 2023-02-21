import ballerina/http;
import ballerinax/jaeger as _;
import ballerina/log;

service /text\-processing on new http:Listener(9099) {

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

