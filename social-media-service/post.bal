import ballerina/http;
type Post record {|
    int id;
    string description;
|};

type NewPost record {|
    string description;
|};

type PostForbidden record {|
    *http:Forbidden;
    ErrorDetails body;
|};