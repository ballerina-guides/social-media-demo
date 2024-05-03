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
import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/sql;
import ballerina/time;
import ballerinax/mysql.driver as _;

configurable boolean moderate = ?;

listener http:Listener socialMediaListener = new (9095);

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service /social\-media on socialMediaListener {

    public function init() returns error? {
        log:printInfo("Social media service started");
    }

    // Service-level error interceptors can handle errors occurred during the service execution.
    public function createInterceptors() returns ResponseErrorInterceptor {
        return new ResponseErrorInterceptor();
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

    # Get posts for a given user
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
        if result is error {
            return result;
        }

        stream<Post, sql:Error?> postStream = socialMediaDb->query(`SELECT id, description, category, created_time_stamp, tags FROM posts WHERE user_id = ${id}`);
        Post[]|error posts = from Post post in postStream
            select post;

        return sortPostsByTime(mapPostToPostWithMeta(check posts, result.name));
    }

    # Get posts from all the users
    #
    # + return - A list of posts or error message
    resource function get posts() returns PostWithMeta[]|error {
        stream<User, sql:Error?> userStream = socialMediaDb->query(`SELECT * FROM users`);
        PostWithMeta[] posts = [];
        User[] users = check from User user in userStream
            select user;

        foreach User user in users {
            stream<Post, sql:Error?> postStream = socialMediaDb->query(`SELECT id, description, category, created_time_stamp, tags FROM posts WHERE user_id = ${user.id}`);
            Post[]|error userPosts = from Post post in postStream
                select post;
            PostWithMeta[] postsWithMeta = mapPostToPostWithMeta(check userPosts, user.name);
            posts.push(...postsWithMeta);
        }
        return sortPostsByTime(posts);
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

        Sentiment sentiment = check sentimentEndpoint->/api/sentiment.post(
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
            INSERT INTO posts(description, category, created_time_stamp, tags, user_id)
            VALUES (${newPost.description}, ${newPost.category}, CURRENT_TIMESTAMP(), ${newPost.tags}, ${id});`);
        return http:CREATED;
    }

    resource function get users/[int id]/following/posts() returns PostWithMeta[]|UserNotFound|error {
        User|error user = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${id}`);
        if user is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/following/posts`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }
        if user is error {
            return user;
        }

        stream<LeaderId, sql:Error?> followingStream = socialMediaDb->query(`SELECT leader_id FROM followers WHERE follower_id = ${id}`);
        PostWithMeta[] posts = [];
        LeaderId[] followingArr = check from LeaderId following in followingStream
            select following;
        foreach LeaderId following in followingArr {
            User|error userStream = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${following.leaderId}`);
            if userStream is sql:NoRowsError {
                ErrorDetails errorDetails = buildErrorPayload(string `id: ${following.leaderId}`, string `users/${following.leaderId}/following/posts`);
                UserNotFound userNotFound = {
                    body: errorDetails
                };
                return userNotFound;
            }
            if userStream is error {
                return userStream;
            }

            stream<Post, sql:Error?> postStream = socialMediaDb->query(`SELECT id, description, category, created_time_stamp, tags FROM posts WHERE user_id = ${following.leaderId}`);
            Post[]|error userPosts = from Post post in postStream
                select post;
            posts.push(...mapPostToPostWithMeta(check userPosts, userStream.name));
        }
        return sortPostsByTime(posts);
    }

    # Get following for a given user
    #
    # + id - The user ID for which following are retrieved
    # + return - A list of following or error message
    resource function get users/[int id]/following() returns User[]|UserNotFound|error {
        User|error result = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${id}`);
        if result is sql:NoRowsError {
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${id}`, string `users/${id}/following`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }
        if result is error {
            return result;
        }

        stream<LeaderId, sql:Error?> followingStream = socialMediaDb->query(`SELECT leader_id FROM followers WHERE follower_id = ${id}`);
        User[] followingUsers = [];
        LeaderId[] followings = check from LeaderId following in followingStream
            select following;
        foreach LeaderId followingRecord in followings {
            User|error user = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${followingRecord.leaderId}`);
            if user is error {
                return user;
            }
            followingUsers.push(user);
        }
        return followingUsers;
    }

    # Follow a user
    #
    # + id - The user ID of the user to be followed
    # + return - The success message or error message
    resource function post users/[int id]/following(int leaderId) returns http:Created|UserNotFound|error {
        User|error leader = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${leaderId}`);
        User|error follower = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${id}`);
        if leader is sql:NoRowsError || follower is sql:NoRowsError {
            int errorId = leader is sql:NoRowsError ? leaderId : id;
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${errorId}`, string `users/${errorId}/following`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }
        if leader is error {
            return leader;
        }
        if follower is error {
            return follower;
        }

        _ = check socialMediaDb->execute(`
                INSERT INTO followers(created_time_stamp, leader_id, follower_id)
                VALUES (CURRENT_TIMESTAMP(), ${leaderId}, ${id});`);
        return http:CREATED;
    }

    # Unfollow a user
    #
    # + id - The user ID of the user to be unfollowed
    # + return - The success message or error message
    resource function delete users/[int id]/following(int leaderId) returns http:NoContent|UserNotFound|error {
        User|error leader = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${leaderId}`);
        User|error follower = socialMediaDb->queryRow(`SELECT * FROM users WHERE id = ${id}`);
        if leader is sql:NoRowsError || follower is sql:NoRowsError {
            int errorId = leader is sql:NoRowsError ? leaderId : id;
            ErrorDetails errorDetails = buildErrorPayload(string `id: ${errorId}`, string `users/${errorId}/following`);
            UserNotFound userNotFound = {
                body: errorDetails
            };
            return userNotFound;
        }
        if leader is error {
            return leader;
        }
        if follower is error {
            return follower;
        }

        _ = check socialMediaDb->execute(`
                DELETE FROM followers WHERE leader_id = ${leaderId} AND follower_id = ${id};`);
        return http:NO_CONTENT;
    }
}

function buildErrorPayload(string msg, string path) returns ErrorDetails => {
    message: msg,
    timeStamp: time:utcNow(),
    details: string `uri=${path}`
};

function mapPostToPostWithMeta(Post[] posts, string author) returns PostWithMeta[] => from var postItem in posts
    select {
        id: postItem.id,
        description: postItem.description,
        author,
        meta: {
            tags: regex:split(postItem.tags, ","),
            category: postItem.category,
            createdTimeStamp: postItem.createdTimeStamp
        }
    };

function sortPostsByTime(PostWithMeta[] unsortedPosts) returns PostWithMeta[]|error {
    foreach var item in unsortedPosts {
        item.meta.createdTimeStamp.timeAbbrev = "z";
    }
    PostWithMeta[] sortedPosts = from var post in unsortedPosts
        order by check time:civilToString(post.meta.createdTimeStamp) descending
        select post;
    return sortedPosts;
}

type Probability record {
    decimal neg;
    decimal neutral;
    decimal pos;
};

type Sentiment record {
    Probability probability;
    string label;
};
