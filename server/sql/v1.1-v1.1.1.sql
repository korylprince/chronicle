/* Run v1.1.1.sql first */

INSERT INTO user(uid, username, fullname, id) 
SELECT uid, username, fullname, UNHEX(MD5(CONCAT(uid, username, fullname))) FROM chronicle GROUP BY uid, CONVERT(username, BINARY(500)), CONVERT(fullname, BINARY(500));

UPDATE chronicle SET clientidentifier="missing" WHERE clientidentifier IS NULL;

INSERT INTO device(serial, clientidentifier, hostname, id) 
SELECT DISTINCT BINARY serial, clientidentifier, hostname, UNHEX(MD5(CONCAT(serial, clientidentifier, hostname))) FROM chronicle GROUP BY CONVERT(serial, BINARY(500)), CONVERT(clientidentifier, BINARY(500)), CONVERT(hostname, BINARY(500));

INSERT INTO address(ip, internetip, id) 
    SELECT DISTINCT BINARY ip, internetip, UNHEX(MD5(CONCAT(ip, internetip))) FROM chronicle GROUP BY ip, internetip;

INSERT INTO log(user_id, device_id, address_id, time)
    SELECT UNHEX(MD5(CONCAT(uid, username, fullname))), UNHEX(MD5(CONCAT(serial, clientidentifier, hostname))), UNHEX(MD5(CONCAT(ip, internetip))), time FROM chronicle;

/* Drop chronicle table when done */
