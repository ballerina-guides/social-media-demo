import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// Initializes the database as a prerequisite to `Database Access` samples.
public function main() returns sql:Error? {
    mysql:Client mysqlClient = check new (host = "localhost", port = 3306, user = "root", password = "dummypassword");

    // Creates `users` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.users (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        birth_date date,
                                        name varchar(255)
                                    );`);

    // Creates `posts` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.posts (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        description varchar(255),
                                        category varchar(255),
                                        created_date date,
                                        tags varchar(255),
                                        user_id int
                                    );`);

    // Add foreign key to `posts` table in the database.
    _ = check mysqlClient->execute(`ALTER TABLE social_media_database.posts
                                    ADD FOREIGN KEY (user_id)
                                    REFERENCES social_media_database.users(id) ON DELETE CASCADE;`);

    // Add new column to `users` table in the database.
    _ = check mysqlClient->execute(`ALTER TABLE social_media_database.users
                                    ADD mobile_number varchar(15) NOT NULL;`);

    // Adds the records to the `users` table.
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(id, birth_date, name, mobile_number)
                                    VALUES(1, CURDATE(), "Ranga", "+94771234001");`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(id, birth_date, name, mobile_number)
                                    VALUES(2, CURDATE(), "Ravi", "+94771234002");`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(id, birth_date, name, mobile_number)
                                    VALUES(3, CURDATE(), "Satish", "+94771234001");`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(id, birth_date, name, mobile_number)
                                    VALUES(4, CURDATE(), "Ayesh", "+94768787189");`);                               


    // Adds the records to the `posts` table.
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn AWS', 'education', CURDATE(), 'aws,cloud,learn',1);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn DevOps', 'education', CURDATE(), 'devops,infra,learn', 1);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn GCP', 'education', CURDATE(), 'gcp,google,learn', 2);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn multi cloud', 'education', CURDATE(), 'gcp,aws,azure,infra,learn', 3);`);

    // Creates `followers` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.followers (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        created_date date,
                                        leader_id int,
                                        follower_id int,
                                        UNIQUE (leader_id, follower_id), 
                                        FOREIGN KEY (leader_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE,
                                        FOREIGN KEY (follower_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE
                                    );`);

    _ = check mysqlClient->execute(`INSERT INTO social_media_database.followers(created_date, leader_id, follower_id)
                                    VALUES(CURDATE(), 1, 4);`); 
    check mysqlClient.close();
}
