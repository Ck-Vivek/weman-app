package models

import "time"

type ReelItem struct {
	ID             string    `json:"id"`
	CreatorID      string    `json:"creator_id"`
	CreatorHandle  string    `json:"creator_handle"`
	CreatorName    string    `json:"creator_name"`
	CampusHub      string    `json:"campus_hub"`
	VideoURL       string    `json:"video_url"`
	ThumbnailURL   string    `json:"thumbnail_url"`
	Caption        string    `json:"caption"`
	AudioTrack     string    `json:"audio_track"`
	LinkedExercise string    `json:"linked_exercise"`
	LikesCount     int       `json:"likes_count"`
	CommentsCount  int       `json:"comments_count"`
	BookmarksCount int       `json:"bookmarks_count"`
	Tags           []string  `json:"tags"`
	CreatedAt      time.Time `json:"created_at"`
}

type UploadTokenResponse struct {
	UploadURL string `json:"upload_url"`
	AssetID   string `json:"asset_id"`
	ExpiresAt int64  `json:"expires_at"`
}
