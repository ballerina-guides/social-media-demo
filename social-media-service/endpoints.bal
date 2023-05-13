import ballerinax/mysql;

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

