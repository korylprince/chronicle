CREATE TEMPORARY TABLE tmp_ids (
    id INT NOT NULL PRIMARY KEY
);

/* First Day -> Untouched */
INSERT INTO tmp_ids SELECT id FROM log WHERE time > NOW() - INTERVAL 1 DAY;

/* First Week -> Keep first/last record for each hour per data set */ 
INSERT IGNORE INTO tmp_ids SELECT ids.id FROM (
    SELECT Min(id) as id FROM log GROUP BY DATE_FORMAT(time,'%Y-%m-%d-%H:00:00'), user_id, device_id, address_id
    UNION SELECT Max(id) as id FROM log GROUP BY DATE_FORMAT(time,'%Y-%m-%d-%H:00:00'), user_id, device_id, address_id
) as ids JOIN log on ids.id = log.id WHERE log.time > NOW() - INTERVAL 1 WEEK;

/* First Month -> Keep first/last record for each day per data set */ 
INSERT IGNORE INTO tmp_ids SELECT ids.id FROM (
    SELECT Min(id) as id FROM log GROUP BY DATE(time), user_id, device_id, address_id
    UNION SELECT Max(id) as id FROM log GROUP BY DATE(time), user_id, device_id, address_id
) as ids JOIN log on ids.id = log.id WHERE log.time > NOW() - INTERVAL 1 MONTH;

/* First Year -> Keep first/last record for each week per data set */ 
INSERT IGNORE INTO tmp_ids SELECT ids.id FROM (
    SELECT Min(id) as id FROM log GROUP BY WEEK(time), user_id, device_id, address_id
    UNION SELECT Max(id) as id FROM log GROUP BY WEEK(time), user_id, device_id, address_id
) as ids JOIN log on ids.id = log.id WHERE log.time > NOW() - INTERVAL 1 YEAR;

/* Everything Else -> Keep first/last record for each month per data set */ 
INSERT IGNORE INTO tmp_ids SELECT id FROM (
    SELECT Min(id) as id FROM log GROUP BY MONTH(time), user_id, device_id, address_id
    UNION SELECT Max(id) as id FROM log GROUP BY MONTH(time), user_id, device_id, address_id
) as ids;

DELETE FROM log WHERE id NOT IN (SELECT id FROM tmp_ids);

DROP TABLE tmp_ids;
