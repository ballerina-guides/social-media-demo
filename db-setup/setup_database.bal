import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// Initializes the database as a prerequisite to `Database Access` samples.
public function main() returns sql:Error? {
    mysql:Client mysqlClient = check new (host = "localhost", port = 3306, user = "root", password = "dummypassword");

    // Creates `albums` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.users (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        birth_date date,
                                        name varchar(255)
                                    );`);

    // Creates `albums` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.posts (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        description varchar(255),
                                        category varchar(255),
                                        created_date date,
                                        tags varchar(255),
                                        user_id int
                                    );`);

    // Creates `albums` table in the database.
    _ = check mysqlClient->execute(`ALTER TABLE social_media_database.posts
                                    ADD FOREIGN KEY (user_id)
                                    REFERENCES social_media_database.users(id) ON DELETE CASCADE;`);

    // Adds the records to the `albums` table.
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(birth_date, name)
                                    VALUES(CURDATE(), "Ranga");`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(birth_date, name)
                                    VALUES(CURDATE(), 'Ravi');`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.users(birth_date, name)
                                    VALUES(CURDATE(), 'Satish');`);                               


    // Adds the records to the `artists` table.
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn AWS', 'education', CURDATE(), 'aws, cloud, learn',1);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn DevOps', 'education', CURDATE(), 'devops, infra, learn', 1);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn GCP', 'education', CURDATE(), 'gcp, google, learn', 2);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.posts(description, category, created_date, tags, user_id)
                                    VALUES ('I want to learn multi cloud', 'education', CURDATE(), 'gcp, aws, azure, infra, learn', 3);`);

    check mysqlClient.close();
}