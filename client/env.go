package main

import (
	"log"

	"github.com/kelseyhightower/envconfig"
)

//Config stores configuration from the environment
type Config struct {
	Chronicler string
	TLS        bool
	Interval   int //in Minutes
	proto      string
}

var config = &Config{}

func init() {
	err := envconfig.Process("CHRONICLE", config)
	if err != nil {
		log.Panicln("Error reading configuration from environment:", err)
	}
	if config.Chronicler == "" {
		log.Fatalln("CHRONICLE_CHRONICLER must be configured")
	}
	if config.TLS {
		config.proto = "https"
	} else {
		config.proto = "http"
	}
	if config.Interval == 0 {
		config.Interval = 5
		log.Println("CHRONICLE_INTERVAL not set. Defaulting to 5 minutes")
	}
	log.Printf("Config: %#v\n", *config)
}
