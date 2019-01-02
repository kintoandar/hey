package main

import (
	"flag"
	"log"
	"net/http"
	"os"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// Index response
func Index(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hey!"))
}

// Health response
func Health(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

func main() {
	var bind string
	flag := flag.NewFlagSet(os.Args[0], flag.ExitOnError)
	flag.StringVar(&bind, "bind", ":8000", "Server bind definition")
	flag.Parse(os.Args[1:])

	http.HandleFunc("/", prometheus.InstrumentHandlerFunc("/", Index))
	http.HandleFunc("/health", prometheus.InstrumentHandlerFunc("/health", Health))
	http.Handle("/metrics", promhttp.Handler())

	log.Println("Starting server at [" + bind + "]")
	log.Fatal(http.ListenAndServe(bind, nil))
}
