package main

import "time"

//Entry represents information about a computer
type Entry struct {
	UID              uint32    `json:"uid"`
	Username         string    `json:"username"`
	FullName         string    `json:"full_name"`
	Serial           string    `json:"serial"`
	ClientIdentifier string    `json:"client_identifier"`
	Hostname         string    `json:"hostname"`
	IP               string    `json:"ip"`
	InternetIP       string    `json:"internet_ip,omitempty"`
	Time             time.Time `json:"time,omitempty"`
}
