CREATE TABLE social_media_database.users (
    id INT NOT NULL auto_increment PRIMARY KEY,
    birth_date DATE,
    name VARCHAR(255)
);
CREATE TABLE social_media_database.posts (
    id INT NOT NULL auto_increment PRIMARY KEY,
    description VARCHAR(255),
    category VARCHAR(255),
    created_date DATE,
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
        Curdate(),
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
        Curdate(),
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
        Curdate(),
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
        Curdate(),
        "ayesh",
        "+94768787189"
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_date,
        tags,
        user_id
    )
VALUES (
        'I want to learn AWS',
        'education',
        Curdate(),
        'aws,cloud,learn',
        1
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_date,
        tags,
        user_id
    )
VALUES (
        'I want to learn DevOps',
        'education',
        Curdate(),
        'devops,infra,learn',
        1
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_date,
        tags,
        user_id
    )
VALUES (
        'I want to learn GCP',
        'education',
        Curdate(),
        'gcp,google,learn',
        2
    );
INSERT INTO social_media_database.posts (
        description,
        category,
        created_date,
        tags,
        user_id
    )
VALUES (
        'I want to learn multi cloud',
        'education',
        Curdate(),
        'gcp,aws,azure,infra,learn',
        3
    );
CREATE TABLE social_media_database.followers (
    id INT NOT NULL auto_increment PRIMARY KEY,
    created_date DATE,
    leader_id INT,
    follower_id INT,
    UNIQUE (leader_id, follower_id),
    FOREIGN KEY (leader_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE,
    FOREIGN KEY (follower_id) REFERENCES social_media_database.users(id) ON DELETE CASCADE
);
INSERT INTO social_media_database.followers (
        created_date,
        leader_id,
        follower_id
    )
VALUES (Curdate(), 1, 4);
