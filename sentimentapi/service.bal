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
import ballerina/log;

service /text\-processing on new http:Listener(9000) {

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

