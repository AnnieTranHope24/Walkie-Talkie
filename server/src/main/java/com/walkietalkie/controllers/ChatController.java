package com.walkietalkie.controllers;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.walkietalkie.model.ChatMessage;
import com.walkietalkie.repositories.ChatMessageRepository;

@RestController
@RequestMapping("/api")
public class ChatController {
    @Autowired
    private ChatMessageRepository chatMessageRepository;

    @GetMapping(value = "chat")
    public ResponseEntity<List<ChatMessage>> getChatMessages() {
        ArrayList<ChatMessage> messages = new ArrayList<>();
        for (ChatMessage message : chatMessageRepository.findAll()) {
            messages.add(message);
        }
        return new ResponseEntity<List<ChatMessage>>(messages, HttpStatus.OK);
    }
}
