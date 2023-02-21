import ballerina/time;

type ErrorDetails record {|
    time:Utc timeStamp;
    string message;
    string details;
|};