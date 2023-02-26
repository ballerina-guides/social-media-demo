import ballerina/regex;
import ballerina/http;
import ballerina/sql;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/log;
import ballerinax/jaeger as _;
import ballerina/time;

configurable boolean moderate = ?;

type DataBaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};
configurable DataBaseConfig databaseConfig = ?;
final mysql:Client socialMediaDb = check initDbClient();
function initDbClient() returns mysql:Client|error => new (...databaseConfig);

final http:Client sentimentEndpoint = check new ("localhost:9099",
    retryConfig = {
        interval: 3
    },
    auth = {
        refreshUrl: "https://localhost:9445/oauth2/token",
        refreshToken: "24f19603-8565-4b5f-a036-88a945e1f272",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        clientConfig: {
            secureSocket: {
                cert: "./resources/public.crt"
            }
        }
    },
    secureSocket = {
        cert: "./resources/public.crt"
    }
);

listener http:Listener socialMediaListener = new (9090,
    interceptors = [new ResponseErrorInterceptor()]
);
service SocialMedia /social\-media on socialMediaListener {

    public function init() returns error? {
        log:printInfo("Social media service started");
    }

    # Get all the users
    #
    # + return - The list of users or error message
    resource function get users() returns User[]|error {
        stream<User, sql:Error?> userStream = socialMediaDb->query(`SELECT * FROM users`);
        return from User user in userStream
            select user;
    }

    # Get a specific user
    #
    # + id - The user ID of the user to be retrived
    # + return - A specific user or error message
    resource function get users/[int id]() returns User|UserNotFound|error {
        User|error result = socialMediaDb->queryRow(`SELECT * FROM users WHERE ID = ${id}`);
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
        _ = check socialMediaDb->execute(`
            INSERT INTO users(birth_date, name, mobile_number)
            VALUES (${newUser.birthDate}, ${newUser.name}, ${newUser.mobileNumber});`);
        return http:CREATED;
    }

    # Delete a user
    #
    # + id - The user ID of the user to be deleted
    # + return - The success message or error message
    resource function delete users/[int id]() returns http:NoContent|error {
        _ = check socialMediaDb->execute(`
            DELETE FROM users WHERE id = ${id};`);
        return http:NO_CONTENT;
    }

    # Get posts for a give user
    #
    # + id - The user ID for which posts are retrieved
    # + return - A list of posts or error message
    resource function get users/[int id]/posts() returns PostWithMeta[]|UserNotFound|error {
        User|error result = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${id}`);
        if result is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }

        stream<Post, sql:Error?> postStream = socialMediaDb->query(`SELECT id, description, category, created_date, tags FROM posts WHERE user_id = ${id}`);
        Post[]|error posts = from Post post in postStream
            select post;
        return mapPostToPostWithMeta(check posts);
    }

    # Create a post for a given user
    #
    # + id - The user ID for which the post is created
    # + return - The created message or error message
    resource function post users/[int id]/posts(@http:Payload NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error {
        User|error user = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${id}`);
        if user is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }
        if user is error {
            return user;
        }

        Sentiment sentiment = check sentimentEndpoint->/text\-processing/api/sentiment.post(
            {text: newPost.description}
        );
        if sentiment.label == "neg" {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/posts`);
            PostForbidden postForbidden = {
                body: errorDetails
            };
            return postForbidden;
        }

        _ = check socialMediaDb->execute(`
            INSERT INTO posts(description, category, created_date, tags, user_id)
            VALUES (${newPost.description}, ${newPost.category}, CURDATE(), ${newPost.tags}, ${id});`);
        check sendSmsToFollowers(user);
        return http:CREATED;
    }
}

function buildErrorPayload(string msg, string path) returns ErrorDetails => {
        message: msg,
        timeStamp: time:utcNow(),
        details: string `uri=${path}`
    };

function mapPostToPostWithMeta(Post[] post) returns PostWithMeta[] => from var postItem in post
    select {
        id: postItem.id,
        description: postItem.description,
        meta: {
            tags: regex:split(postItem.tags, ","),
            category: postItem.category,
            created_date: postItem.created_date
        }
    };
