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

import ballerina/constraint;
import ballerina/http;

// Handle listener errors
service class ResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    remote function interceptResponseError(http:RequestContext ctx, error err) 
            returns SocialMediaBadRequest|SocialMediaServerError {
        ErrorDetails errorDetails = buildErrorPayload(err.message(), "");
        
        if err is constraint:Error {
            SocialMediaBadRequest socialMediaBadRequest = {
                body: errorDetails
            };
            return socialMediaBadRequest;
        } else {
            SocialMediaServerError socialMediaServerError = {
                body: errorDetails
            };
            return socialMediaServerError;
        }
    }
}

type SocialMediaBadRequest record {|
    *http:BadRequest;
    ErrorDetails body;
|};

type SocialMediaServerError record {|
    *http:InternalServerError;
    ErrorDetails body;
|};
