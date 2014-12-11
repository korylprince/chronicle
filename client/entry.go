package main

//Entry represents information about a computer
type Entry struct {
	UID      uint32 `json:"uid"`
	Username string `json:"username"`
	FullName string `json:"full_name"`
	Serial   string `json:"serial"`
	Hostname string `json:"hostname"`
	IP       string `json:"ip"`
}