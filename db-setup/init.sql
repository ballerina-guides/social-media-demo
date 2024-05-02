CREATE TABLE social_media_database.users (
    id INT NOT NULL auto_increment PRIMARY KEY,
    birth_date DATE,
    name VARCHAR(255)
);
CREATE TABLE social_media_database.posts (
    id INT NOT NULL auto_increment PRIMARY KEY,
    description VARCHAR(255),
    category VARCHAR(255),
    created_time_stamp TIMESTAMP,
    tags VARCHAR(255),
    user_id INT
);
ALTER TABLE social_media_database.posts ADD FOREIGN KEY (user_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE;

ALTER TABLE social_media_database.users ADD mobile_number VARCHAR(15) NOT NULL;

INSERT INTO social_media_database.users (
        id,
        birth_date,
        name,
        mobile_number
    )
VALUES (
        1,
        CURRENT_TIMESTAMP(),
        "ranga",
        "+94771234001"
    );
INSERT INTO social_media_database.users (
        id,
        birth_date,
        name,
        mobile_number
    )
VALUES (
        2,
        CURRENT_TIMESTAMP(),
        "ravi",
        "+94771234002"
    );
INSERT INTO social_media_database.users (
        id,
        birth_date,
        name,
        mobile_number
    )
VALUES (
        3,
        CURRENT_TIMESTAMP(),
        "satish",
        "+94771234001"
    );
INSERT INTO social_media_database.users (
        id,
        birth_date,
        name,
        mobile_number
    )
VALUES (
        4,
        CURRENT_TIMESTAMP(),
        "ayesh",
        "+94768787189"
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_time_stamp,
        tags,
        user_id
    )
VALUES (
        'I want to learn AWS',
        'education',
        CURRENT_TIMESTAMP(),
        'aws,cloud,learn',
        1
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_time_stamp,
        tags,
        user_id
    )
VALUES (
        'I want to learn DevOps',
        'education',
        CURRENT_TIMESTAMP(),
        'devops,infra,learn',
        1
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_time_stamp,
        tags,
        user_id
    )
VALUES (
        'I want to learn GCP',
        'education',
        CURRENT_TIMESTAMP(),
        'gcp,google,learn',
        2
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_time_stamp,
        tags,
        user_id
    )
VALUES (
        'I want to learn multi cloud',
        'education',
        CURRENT_TIMESTAMP(),
        'gcp,aws,azure,infra,learn',
        3
    );
CREATE TABLE social_media_database.followers (
    id INT NOT NULL auto_increment PRIMARY KEY,
    created_time_stamp DATE,
    leader_id INT,
    follower_id INT,
    UNIQUE (leader_id, follower_id),
    FOREIGN KEY (leader_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE,
    FOREIGN KEY (follower_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE
);
INSERT INTO social_media_database.followers (
        created_time_stamp,
        leader_id,
        follower_id
    )
VALUES (CURRENT_TIMESTAMP(), 1, 4);
