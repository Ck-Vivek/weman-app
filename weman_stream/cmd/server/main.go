package main

import (
	"log"
	"net/http"

	"fit.weman/stream/internal/handlers"
)

func main() {
	mux := http.NewServeMux()

	// High speed streaming and reels ingestion endpoints
	mux.HandleFunc("/api/v1/reels", handlers.GetReelsFeed)
	mux.HandleFunc("/api/v1/stream/upload-token", handlers.RequestUploadToken)
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte(`{"status":"UP","service":"weman-stream-go"}`))
	})

	log.Println("WEMAN Stream Service (Go) starting on :8081...")
	if err := http.ListenAndServe(":8081", mux); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
