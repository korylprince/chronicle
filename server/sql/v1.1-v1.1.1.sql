/* Run v1.1.1.sql first */

INSERT INTO user(uid, username, fullname) 
    SELECT DISTINCT uid, username, fullname FROM chronicle GROUP BY uid, CONVERT(username, BINARY(500)), CONVERT(fullname, BINARY(500));

INSERT INTO device(serial, clientidentifier, hostname) 
    SELECT DISTINCT serial, clientidentifier, hostname FROM chronicle GROUP BY CONVERT(serial, BINARY(500)), CONVERT(clientidentifier, BINARY(500)), CONVERT(hostname, BINARY(500));

INSERT INTO address(ip, internetip) 
    SELECT DISTINCT ip, internetip FROM chronicle GROUP BY ip, internetip;

INSERT INTO identity(user_id, device_id, address_id)
    SELECT DISTINCT user.id, device.id, address.id FROM 
        user JOIN device JOIN address JOIN (SELECT * FROM chronicle) AS c WHERE 

        user.uid = c.uid AND 
        user.username = c.username AND 
        user.fullname = c.fullname AND 
        device.serial = c.serial AND 
        device.clientidentifier = c.clientidentifier AND 
        device.hostname = c.hostname AND 
        address.ip = c.ip AND 
        address.internetip = c.internetip

        GROUP BY user.id, device.id, address.id
; 

INSERT INTO log(identity_id, time)
    SELECT DISTINCT identity.id, c.time FROM 
        user JOIN device JOIN address JOIN identity JOIN (SELECT * FROM chronicle) AS c WHERE 

        user.uid = c.uid AND 
        user.username = c.username AND 
        user.fullname = c.fullname AND 
        device.serial = c.serial AND 
        device.clientidentifier = c.clientidentifier AND 
        device.hostname = c.hostname AND 
        address.ip = c.ip AND 
        address.internetip = c.internetip AND
        identity.user_id = user.id AND
        identity.device_id = device.id AND
        identity.address_id = address.id

        GROUP BY identity.id
; 

/* Drop chronicle table when done */
