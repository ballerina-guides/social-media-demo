import ballerina/sql;
import ballerina/time;
import ballerina/constraint;
import ballerina/http;

type User record {|
    int id;
    string name;
    @sql:Column {name: "birth_date"}
    time:Date birthDate;
|};

type NewUser record {|
    @constraint:String {
        minLength: 2
    }
    string name;
    time:Date birthDate;
|};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};