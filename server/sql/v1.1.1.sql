CREATE TABLE user (
    id BINARY(16) PRIMARY KEY, 
    uid INT,
    username VARCHAR(64),
    fullname VARCHAR(128)
);
CREATE INDEX user_uid ON user(uid);
CREATE INDEX user_username ON user(username);
CREATE INDEX user_fullname ON user(fullname);

CREATE TABLE device (
    id BINARY(16) PRIMARY KEY, 
    serial VARCHAR(32),
    clientidentifier VARCHAR(64),
    hostname VARCHAR(32)
);
CREATE INDEX device_serial ON device(serial);
CREATE INDEX device_clientidentifier ON device(clientidentifier);
CREATE INDEX device_hostname ON device(hostname);

CREATE TABLE address (
    id BINARY(16) PRIMARY KEY, 
    ip VARCHAR(15),
    internetip VARCHAR(15)
);
CREATE INDEX address_ip ON address(ip);
CREATE INDEX address_internetip ON address(internetip);

CREATE TABLE log (
    id INT auto_increment PRIMARY KEY, 
    user_id BINARY(16),
    device_id BINARY(16),
    address_id BINARY(16),
    time DATETIME,
    FOREIGN KEY(user_id) REFERENCES user(id),
    FOREIGN KEY(device_id) REFERENCES device(id),
    FOREIGN KEY(address_id) REFERENCES address(id)
);
CREATE INDEX log_time ON log(time);
