CREATE TABLE USER_DETAILS(ID INT AUTO_INCREMENT, BIRTH_DATE DATE, NAME VARCHAR(255));
CREATE TABLE POST(ID IDENTITY PRIMARY KEY, DESCRIPTION VARCHAR(255), USER_ID BIGINT);

ALTER TABLE POST
ADD FOREIGN KEY (USER_ID)
REFERENCES USER_DETAILS(ID) ON DELETE CASCADE;

insert into user_details(birth_date, name)
values(current_date(), 'Ranga');

insert into user_details(birth_date, name)
values(current_date(), 'Ravi');

insert into user_details(birth_date, name)
values(current_date(), 'Sathish');

insert into post(description, user_id)
values('I want to learn AWS', 1);

insert into post(description, user_id)
values('I want to learn DevOps', 1);

insert into post(description, user_id)
values('I want to learn GCP', 2);

insert into post(description, user_id)
values('I want to learn multi cloud', 3);