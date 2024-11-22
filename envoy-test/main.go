package main

import (
	"fmt"
	"net/http"
)

func main() {
	// Handler for the /mtls endpoint
	http.HandleFunc("/mtls", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "mtls")
	})

	// Handler for the /oauth endpoint
	http.HandleFunc("/oauth", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "Oauth")
	})

	// Start the HTTP server on localhost:9888
	port := ":9888"
	fmt.Printf("Starting server on http://localhost%s\n", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}