import ballerina/http;
import ballerina/log;
import ballerina/sql;
import ballerina/time;
import ballerinax/mysql.driver as _;

service SocialMedia /social\-media on new http:Listener(9090) {

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
    resource function post users(NewUser newUser) returns http:Created|error {
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
    resource function get users/[int id]/posts() returns Post[]|UserNotFound|error {
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
        return posts;
    }

    # Create a post for a given user
    #
    # + id - The user ID for which the post is created
    # + return - The created message or error message
    resource function post users/[int id]/posts(NewPost newPost) returns http:Created|UserNotFound|PostForbidden|error {
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
        _ = check socialMediaDb->execute(`
            INSERT INTO posts(description, category, created_date, tags, user_id)
            VALUES (${newPost.description}, ${newPost.category}, CURDATE(), ${newPost.tags}, ${id});`);
        return http:CREATED;
    }
}

function buildErrorPayload(string msg, string path) returns ErrorDetails => {
    message: msg,
    timeStamp: time:utcNow(),
    details: string `uri=${path}`
};
