package fit.weman.core;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("email");
        return ResponseEntity.ok(Map.of(
            "token", "weman-jwt-token-sample-xyz",
            "athlete", Map.of(
                "email", email,
                "name", "Alex Chen",
                "campusHub", "City Engineering College",
                "role", "Student Athlete"
            )
        ));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> payload) {
        return ResponseEntity.ok(Map.of(
            "status", "REGISTERED",
            "athleteId", "ath-991",
            "message", "Welcome to WEMAN Campus Network"
        ));
    }
}
