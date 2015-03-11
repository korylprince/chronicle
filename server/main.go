package main

import (
	"log"
	"net/http"
)

func init() {
	envInit()
	statsInit()
	routesInit()
	dbInit()
}

func main() {
	switch {
	case config.proto == "http":
		log.Println("Starting web server on", config.ListenAddr)
		log.Fatal(http.ListenAndServe(config.ListenAddr, router))
	case config.proto == "https":
		log.Println("Starting web server on", config.ListenAddr)
		log.Fatal(http.ListenAndServeTLS(config.ListenAddr, config.TLSCert, config.TLSKey, router))
	}
}
