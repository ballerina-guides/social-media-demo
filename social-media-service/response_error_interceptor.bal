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