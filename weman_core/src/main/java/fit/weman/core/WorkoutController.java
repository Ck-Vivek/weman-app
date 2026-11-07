package fit.weman.core;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/workouts")
public class WorkoutController {

    @GetMapping("/templates")
    public ResponseEntity<?> getTemplates() {
        return ResponseEntity.ok(List.of(
            Map.of(
                "id", "tpl-01",
                "name", "4-Day Push/Pull/Legs Split",
                "coach", "Coach Alex Chen",
                "duration", "55 min",
                "daysPerWeek", 4
            ),
            Map.of(
                "id", "tpl-02",
                "name", "Metabolic Engine HIIT Conditioning",
                "coach", "Maya Torres",
                "duration", "32 min",
                "daysPerWeek", 3
            )
        ));
    }

    @PostMapping("/sync")
    public ResponseEntity<?> syncOfflineLogs(@RequestBody List<Map<String, Object>> logs) {
        return ResponseEntity.ok(Map.of(
            "syncedRecords", logs.size(),
            "status", "SUCCESS",
            "serverTime", System.currentTimeMillis()
        ));
    }
}
