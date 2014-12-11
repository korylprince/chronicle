package main

import (
	"log"
	"strings"

	"github.com/kelseyhightower/envconfig"
)

//Config stores configuration from the environment
type Config struct {
	ListenAddr string
	TLSCert    string // see http://golang.org/pkg/net/http/#ListenAndServeTLS
	TLSKey     string
	DB         string
	proto      string
}

var config = &Config{}

func envInit() {
	err := envconfig.Process("CHRONICLE", config)
	if err != nil {
		log.Panicln("Error reading configuration from environment:", err)
	}
	if config.ListenAddr == "" {
		log.Fatalln("CHRONICLE_LISTENADDR must be configured")
	}
	if config.TLSCert == "" && config.TLSKey == "" {
		config.proto = "http"
		log.Println("CHRONICLE_TLSCERT not set. Defaulting to http")
	} else if config.TLSCert != "" && config.TLSKey != "" {
		config.proto = "https"
	} else {
		log.Fatalln("If one of CHRONICLE_TLSCERT and CHRONICLE_TLSKEY is set, both must be set")
	}
	if config.DB == "" {
		log.Fatalln("CHRONICLE_DB must be configured")
	}
	if !strings.Contains(config.DB, "parseTime=true") {
		log.Fatalln("CHRONICLE_DB must contain option parseTime=true")
	}
	log.Printf("Config: %#v\n", *config)
}
