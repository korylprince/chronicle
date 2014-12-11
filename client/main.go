package main

import (
	"log"
	"math/rand"
	"time"
)

func main() {
	log.Println("Starting chronicle client")

	interval := config.Interval * 60
	offsetRange := interval / 5

	for {
		err := Submit()
		if err != nil {
			log.Println("Error Sending:", err)
		}
		offset := (rand.Int() % offsetRange) - (offsetRange / 2)
		time.Sleep(time.Second * time.Duration(interval+offset))
	}
}
