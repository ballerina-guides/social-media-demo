import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// Initializes the database as a prerequisite to `Database Access` samples.
public function main() returns sql:Error? {
    mysql:Client mysqlClient = check new (host = "localhost", port = 3306, user = "root", password = "dummypassword");

    // Creates `albums` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.user_details (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        birth_date date,
                                        name varchar(255)
                                    );`);

    // Creates `albums` table in the database.
    _ = check mysqlClient->execute(`CREATE TABLE social_media_database.post (
                                        id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        description varchar(255),
                                        user_id int
                                    );`);

    // Creates `albums` table in the database.
    _ = check mysqlClient->execute(`ALTER TABLE social_media_database.post
                                    ADD FOREIGN KEY (user_id)
                                    REFERENCES social_media_database.user_details(id) ON DELETE CASCADE;`);

    // Adds the records to the `albums` table.
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.user_details(birth_date, name)
                                    VALUES(CURDATE(), "Ranga");`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.user_details(birth_date, name)
                                    VALUES(CURDATE(), 'Ravi');`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.user_details(birth_date, name)
                                    VALUES(CURDATE(), 'Satish');`);                               


    // Adds the records to the `artists` table.
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.post(description, user_id)
                                    VALUES ('I want to learn AWS', 1);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.post(description, user_id)
                                    VALUES ('I want to learn DevOps', 1);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.post(description, user_id)
                                    VALUES ('I want to learn GCP', 2);`);
    _ = check mysqlClient->execute(`INSERT INTO social_media_database.post(description, user_id)
                                    VALUES ('I want to learn multi cloud', 3);`);

    check mysqlClient.close();
}