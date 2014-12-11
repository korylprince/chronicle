CREATE TABLE chronicle (
    id INT auto_increment PRIMARY KEY, 
    uid INT,
    username VARCHAR(64),
    fullname VARCHAR(128),
    serial VARCHAR(32),
    hostname VARCHAR(32),
    ip VARCHAR(15),
    internetip VARCHAR(15),
    time DATETIME
);

CREATE INDEX chronicle_id ON chronicle(id);
CREATE INDEX chronicle_uid ON chronicle(uid);
CREATE INDEX chronicle_username ON chronicle(username);
CREATE INDEX chronicle_fullname ON chronicle(fullname);
CREATE INDEX chronicle_serial ON chronicle(serial);
CREATE INDEX chronicle_hostname ON chronicle(hostname);
CREATE INDEX chronicle_ip ON chronicle(ip);
CREATE INDEX chronicle_internetip ON chronicle(internetip);
CREATE INDEX chronicle_time ON chronicle(time);
