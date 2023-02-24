import ballerina/sql;
import ballerina/time;

type Follower record {|
    int id;
    @sql:Column {name: "created_date"}
    time:Date createdDate;
    @sql:Column {name: "leader_id"}
    int leaderId;
    @sql:Column {name: "follower_id"}
    time:Date followerId;
|};
