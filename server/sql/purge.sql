CREATE TEMPORARY TABLE tmp_ids (
    id INT NOT NULL PRIMARY KEY
);

/* First Day -> Untouched */
INSERT INTO tmp_ids SELECT id FROM chronicle WHERE time > NOW() - INTERVAL 1 DAY;

/* First Week -> Keep first/last record for each hour per data set */ 
INSERT IGNORE INTO tmp_ids SELECT ids.id FROM (
    SELECT Min(id) as id FROM chronicle GROUP BY DATE_FORMAT(time,'%Y-%m-%d-%H:00:00'), username, serial, ip, internetip
    UNION SELECT Max(id) as id FROM chronicle GROUP BY DATE_FORMAT(time,'%Y-%m-%d-%H:00:00'), username, serial, ip, internetip
) as ids JOIN chronicle on ids.id = chronicle.id WHERE chronicle.time > NOW() - INTERVAL 1 WEEK;

/* First Month -> Keep first/last record for each day per data set */ 
INSERT IGNORE INTO tmp_ids SELECT ids.id FROM (
    SELECT Min(id) as id FROM chronicle GROUP BY DATE(time), username, serial, ip, internetip
    UNION SELECT Max(id) as id FROM chronicle GROUP BY DATE(time), username, serial, ip, internetip
) as ids JOIN chronicle on ids.id = chronicle.id WHERE chronicle.time > NOW() - INTERVAL 1 MONTH;

/* First Year -> Keep first/last record for each week per data set */ 
INSERT IGNORE INTO tmp_ids SELECT ids.id FROM (
    SELECT Min(id) as id FROM chronicle GROUP BY WEEK(time), username, serial, ip, internetip
    UNION SELECT Max(id) as id FROM chronicle GROUP BY WEEK(time), username, serial, ip, internetip
) as ids JOIN chronicle on ids.id = chronicle.id WHERE chronicle.time > NOW() - INTERVAL 1 YEAR;

/* Everything Else -> Keep first/last record for each month per data set */ 
INSERT IGNORE INTO tmp_ids SELECT id FROM (
    SELECT Min(id) as id FROM chronicle GROUP BY MONTH(time), username, serial, ip, internetip
    UNION SELECT Max(id) as id FROM chronicle GROUP BY MONTH(time), username, serial, ip, internetip
) as ids;

DELETE FROM chronicle WHERE id NOT IN (SELECT id FROM tmp_ids);

DROP TABLE tmp_ids;
