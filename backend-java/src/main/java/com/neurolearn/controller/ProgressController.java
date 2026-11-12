package com.neurolearn.controller;

import com.neurolearn.dto.ProgressResponse;
import com.neurolearn.service.ProgressService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/** STUDENT only (see SecurityConfig). */
@RestController
@RequestMapping("/api/progress")
public class ProgressController {

    private final ProgressService progressService;

    public ProgressController(ProgressService progressService) {
        this.progressService = progressService;
    }

    @GetMapping
    public ResponseEntity<ProgressResponse> getProgress(
            @RequestParam(required = false, defaultValue = "linear_eq_2var") String chapterId,
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        return ResponseEntity.ok(progressService.getProgress(userDetails.getUsername(), chapterId));
    }

    @PostMapping("/boss-victory")
    public ResponseEntity<ProgressResponse> recordBossVictory(
            @RequestBody(required = false) Map<String, Object> body,
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        Map<String, Object> b = body != null ? body : Map.of();
        String bossTopic = b.get("bossTopic") != null ? b.get("bossTopic").toString() : "final_boss";
        String chapterId = b.get("chapterId") != null ? b.get("chapterId").toString() : "linear_eq_2var";
        Long sessionId;
        try {
            sessionId = b.get("sessionId") != null ? Long.valueOf(b.get("sessionId").toString()) : null;
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("sessionId must be a number");
        }
        return ResponseEntity.ok(progressService.awardBossDefeatBonus(userDetails.getUsername(), sessionId, bossTopic, chapterId));
    }
}
