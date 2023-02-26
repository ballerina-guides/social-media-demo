import ballerina/http;
import ballerina/sql;
import ballerina/time;
import ballerina/constraint;

type SocialMedia service object {
    *http:Service;

    // users resource
    resource function get users() returns User[]|error;
    resource function get users/[int id]() returns User|UserNotFound|error;
    resource function post users(@http:Payload NewUser newUser) returns http:Created|error;
    resource function delete users/[int id]() returns http:NoContent|error;

    // posts resource
    resource function get users/[int id]/posts() returns PostWithMeta[]|UserNotFound|error;
    resource function post users/[int id]/posts(@http:Payload NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error;
};

// user representations
type User record {|
    int id;
    string name;
    @sql:Column {name: "birth_date"}
    time:Date birthDate;
    @sql:Column {name: "mobile_number"}
    string mobileNumber;
|};
type NewUser record {|
    @constraint:String {
        minLength: 2
    }
    string name;
    time:Date birthDate;
    string mobileNumber;
|};
type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

// post representations
type Post record {|
    int id;
    string description;
    string tags;
    string category;
    @sql:Column {name: "created_date"}
    time:Date created_date;
|};
type PostWithMeta record {|
    int id;
    string description;
    record {|
        string[] tags;
        string category;
        @sql:Column {name: "created_date"}
        time:Date created_date;
    |} meta;
|};
type NewPost record {|
    string description;
    string tags;
    string category;
|};
type PostForbidden record {|
    *http:Forbidden;
    ErrorDetails body;
|};