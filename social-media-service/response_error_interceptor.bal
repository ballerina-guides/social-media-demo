import ballerina/http;
import ballerina/constraint;

// Handle listener errors
service class ResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    remote function interceptResponseError(http:RequestContext ctx, error err) 
            returns SocialMediaBadReqeust|SocialMediaServerError {
        ErrorDetails errorDetails = buildErrorPayload(err.message(), "");
        
        if err is constraint:Error {
            SocialMediaBadReqeust socialMediaBadRequest = {
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

type SocialMediaBadReqeust record {|
    *http:BadRequest;
    ErrorDetails body;
|};

type SocialMediaServerError record {|
    *http:InternalServerError;
    ErrorDetails body;
|};