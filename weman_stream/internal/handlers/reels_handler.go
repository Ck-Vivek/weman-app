package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"fit.weman/stream/internal/models"
)

var sampleReels = []models.ReelItem{
	{
		ID:             "reel-101",
		CreatorID:      "user-001",
		CreatorHandle:  "@jordan_prime",
		CreatorName:    "Jordan Prime",
		CampusHub:      "City Engineering College",
		VideoURL:       "https://storage.weman.fit/streams/squat-clinic.mp4",
		ThumbnailURL:   "https://storage.weman.fit/thumbs/squat-clinic.jpg",
		Caption:        "3 cues to instantly fix your squat depth and protect your lumbar spine 🔥 #SquatMechanics #LegDay",
		AudioTrack:     "Original Audio — Jordan Prime • Heavy Bass Synth (132 BPM)",
		LinkedExercise: "Barbell Back Squat",
		LikesCount:     48200,
		CommentsCount:  1400,
		BookmarksCount: 8900,
		Tags:           []string{"SquatMechanics", "LegDay", "KarnatakaFit"},
		CreatedAt:      time.Now(),
	},
	{
		ID:             "reel-102",
		CreatorID:      "user-002",
		CreatorHandle:  "@maya.lifts",
		CreatorName:    "Maya Lifts",
		CampusHub:      "CMRIT Indiranagar Hub",
		VideoURL:       "https://storage.weman.fit/streams/rdl-pr.mp4",
		ThumbnailURL:   "https://storage.weman.fit/thumbs/rdl-pr.jpg",
		Caption:        "Hit a clean 4x8 PR on RDLs today with the 6 AM squad! Focus on eccentric tempo. 🔋",
		AudioTrack:     "High Energy Workout Beats — Vol. 4",
		LinkedExercise: "Romanian Deadlift",
		LikesCount:     24300,
		CommentsCount:  620,
		BookmarksCount: 4100,
		Tags:           []string{"Hypertrophy", "Deadlift", "CampusLift"},
		CreatedAt:      time.Now(),
	},
}

func GetReelsFeed(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(sampleReels)
}

func RequestUploadToken(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	resp := models.UploadTokenResponse{
		UploadURL: "https://upload.weman.fit/v1/raw-assets/temp-asset-9921",
		AssetID:   "asset-9921",
		ExpiresAt: time.Now().Add(15 * time.Minute).Unix(),
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(resp)
}
