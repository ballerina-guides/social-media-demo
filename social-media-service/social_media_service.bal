import ballerina/http;
import ballerina/sql;
import ballerina/mime;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/log;
import ballerinax/jaeger as _;
import ballerina/time;

configurable boolean moderate = ?;
configurable string database_user = ?;
configurable string database_password = ?;
configurable string host = ?;
configurable int port = ?;

listener http:Listener socialMediaListener = new (9090,
    interceptors = [new ResponseErrorInterceptor()]
);

service /social\-media on socialMediaListener {

    final mysql:Client socialMediaDb;
    final http:Client sentimentEndpoint;

    public function init() returns error? {
        self.socialMediaDb = check new (host = host, port = port, user = database_user, password = database_password);
        self.sentimentEndpoint = check new("localhost:9099", 
            retryConfig = {
                interval: 3
            }
        );
        log:printInfo("Social media service started");
    }
    
    # Get all the users
    # 
    # + return - The list of users or error message
    resource function get users() returns User[]|error {
        stream<User, sql:Error?> userStream = self.socialMediaDb->query(`SELECT * FROM social_media_database.user_details`);
        return from User user in userStream
            select user;
    }

    # Get a specific user
    # 
    # + id - The user ID of the user to be retrived
    # + return - A specific user or error message
    resource function get users/[int id]() returns User|UserNotFound|error {
        User|error result = self.socialMediaDb->queryRow(`SELECT * FROM social_media_database.user_details WHERE ID = ${id}`);
        if result is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        } else {
            return result;
        }
    }

    # Create a new user
    # 
    # + newUser - The user details of the new user
    # + return - The created message or error message
    resource function post users(@http:Payload NewUser newUser) returns http:Created|error {
        _ = check self.socialMediaDb->execute(`
            INSERT INTO social_media_database.user_details(birth_date, name)
            VALUES (${newUser.birthDate}, ${newUser.name});`);
        return http:CREATED;
    }

    # Delete a user
    # 
    # + id - The user ID of the user to be deleted
    # + return - The success message or error message
    resource function delete users/[int id]() returns http:NoContent|error {
        _ = check self.socialMediaDb->execute(`
            DELETE FROM social_media_database.user_details WHERE id = ${id};`);
        return http:NO_CONTENT;
    }

    # Get posts for a give user
    # 
    # + id - The user ID for which posts are retrieved
    # + return - A list of posts or error message
    resource function get users/[int id]/posts() returns Post[]|UserNotFound|error {
        User|error result = self.socialMediaDb->queryRow(`SELECT * FROM social_media_database.user_details WHERE id = ${id}`);
        if result is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }

        stream<Post, sql:Error?> postStream = self.socialMediaDb->query(`SELECT id, description FROM social_media_database.post WHERE user_id = ${id}`);
        Post[]|error posts = from Post post in postStream
            select post;
        return posts;
    }

    # Create a post for a given user
    # 
    # + id - The user ID for which the post is created
    # + return - The created message or error message
    resource function post users/[int id]/posts(@http:Payload NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error {
        User|error result = self.socialMediaDb->queryRow(`SELECT * FROM social_media_database.user_details WHERE id = ${id}`);
        if result is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }

        Sentiment sentiment = check self.sentimentEndpoint->/text\-processing/api/sentiment.post(
            { text: newPost },
            mediatype = mime:APPLICATION_FORM_URLENCODED
        );
        if sentiment.label == "neg" {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            PostForbidden postForbidden = {
                body: errorDetails
            };
            return postForbidden;
        }

        _ = check self.socialMediaDb->execute(`
            INSERT INTO social_media_database.post(description, user_id)
            VALUES (${newPost.description}, ${id});`);
        return http:CREATED;
    }
}

function buildErrorPayload(string msg, string path) returns ErrorDetails {
    ErrorDetails errorDetails = {
        message: msg,
        timeStamp: time:utcNow(),
        details: string `uri=${path}`
    };
    return errorDetails;
}
