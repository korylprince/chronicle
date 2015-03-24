package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/thoas/stats"
)

var httpStats *stats.Stats

func statsInit() {
	httpStats = stats.New()
	fmt.Println(httpStats.Data())
}

//StatsHandler returns the current stats
func StatsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	e := json.NewEncoder(w)
	err := e.Encode(httpStats.Data())
	if err != nil {
		log.Println("Error encoding data:", err)
	}
}
