package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

var router http.Handler

const apiPrefix = "/api/v1.1"

//Submit takes an Entry and commits it to the DB
func Submit(rw http.ResponseWriter, r *http.Request) {
	e := &Entry{}
	d := json.NewDecoder(r.Body)
	err := d.Decode(e)
	if err != nil {
		log.Println("Error decoding JSON:", err)
		rw.WriteHeader(http.StatusBadRequest)
		return
	}
	addr := strings.Split(r.RemoteAddr, ":")
	if len(addr) == 0 {
		log.Panicln("No Remote Address set")
	}
	if ip := r.Header.Get("X-Forwarded-For"); ip != "" {
		e.InternetIP = ip
	} else {
		addr := strings.Split(r.RemoteAddr, ":")
		if len(addr) == 0 {
			log.Panicln("No Remote Address set")
		}
		e.InternetIP = addr[0]
	}
	e.Time = time.Now()

	err = Commit(e)
	if err != nil {
		if _, ok := err.(ValidationError); ok {
			log.Println("Validation Error:", err)
			rw.WriteHeader(http.StatusBadRequest)
			return
		}
		log.Println("Error committing to DB:", err)
		rw.WriteHeader(http.StatusInternalServerError)
		return
	}
	log.Printf("%#v\n", e)
}

func routesInit() {
	r := mux.NewRouter()
	r.Handle(apiPrefix+"/submit", http.HandlerFunc(Submit)).Methods("POST")
	r.Handle("/stats", http.HandlerFunc(StatsHandler)).Methods("GET")
	router = httpStats.Handler(handlers.CompressHandler(handlers.CombinedLoggingHandler(os.Stdout, r)))
}
