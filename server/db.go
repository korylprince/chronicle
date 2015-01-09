package main

import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
	"log"
)

var db *sql.DB

func dbInit() {
	var err error
	db, err = sql.Open("mysql", config.DB)
	if err != nil {
		log.Fatalln("Error opening database:", err)
	}
}

//Commit validates the entry then attempts to insert in into the DB
func Commit(e *Entry) error {
	if err := Validate(e); err != nil {
		return err
	}
	_, err := db.Exec("INSERT INTO chronicle(uid, username, fullname, serial, clientidentifier, hostname, ip, internetip, time) Values(?, ?, ?, ?, ?, ?, ?, ?, ?);",
		e.UID, e.Username, e.FullName, e.Serial, e.ClientIdentifier, e.Hostname, e.IP, e.InternetIP, e.Time)
	return err
}
