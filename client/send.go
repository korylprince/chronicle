package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"time"
)

const apiPrefix = "/api/v1.1"

//Submit generates an Entry and sends it to a Chronicler
func Submit() error {
	entry := Collect()

	//a custom dialer is required to get local IP
	var req *http.Request
	dial := func(network, addr string) (net.Conn, error) {
		conn, err := net.Dial(network, addr)
		if err != nil {
			return conn, err
		}
		entry.IP = conn.LocalAddr().(*net.TCPAddr).IP.String()
		var buf bytes.Buffer
		e := json.NewEncoder(&buf)
		err = e.Encode(entry)
		if err != nil {
			return conn, err
		}
		req.Body = ioutil.NopCloser(&buf)
		req.ContentLength = int64(buf.Len())
		return conn, err
	}

	t := http.Transport{Dial: dial}
	client := http.Client{Transport: &t, Timeout: time.Second * 5}

	var err error
	//body will be set by custom dialer
	req, err = http.NewRequest("POST", config.proto+"://"+config.Chronicler+apiPrefix+"/submit", nil)
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	if resp.StatusCode != 200 {
		return fmt.Errorf("Request not completed successfully")
	}
	log.Printf("Submitted: %#v\n", entry)
	return nil
}
