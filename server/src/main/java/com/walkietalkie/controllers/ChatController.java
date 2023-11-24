package com.walkietalkie.controllers;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.walkietalkie.model.ChatMessage;
import com.walkietalkie.repositories.ChatMessageRepository;
import com.walkietalkie.repositories.UserRepository;

@RestController
@RequestMapping("/api")
public class ChatController {
    @Autowired
    private ChatMessageRepository chatMessageRepository;
    @Autowired
    private UserRepository userRepository;

    private static record ChatMessageFromTo(String SenderUserName, String ReceiverUserName) {};
    private static record ChatMessageInfo(String SenderUserName, String ReceiverUserName, String Type, String Content) {};

    @GetMapping(value = "chat/all")
    public ResponseEntity<List<ChatMessage>> getChatMessages() {
        ArrayList<ChatMessage> messages = new ArrayList<>();
        for (ChatMessage message : chatMessageRepository.findAll()) {
            messages.add(message);
        }
        return new ResponseEntity<List<ChatMessage>>(messages, HttpStatus.OK);
    }

    @PostMapping(value = "chat/getChatMessages")
    public ResponseEntity<List<ChatMessage>> getChatMessages(@RequestBody ChatMessageFromTo info) {
        ArrayList<ChatMessage> messages = new ArrayList<>();
        for (ChatMessage message : chatMessageRepository.findAll()) {
            if (message.getSender().getUserName().equals(info.SenderUserName) && message.getReceiver().getUserName().equals(info.ReceiverUserName)) {
                messages.add(message);
            }
            if (message.getSender().getUserName().equals(info.ReceiverUserName) && message.getReceiver().getUserName().equals(info.SenderUserName)) {
                messages.add(message);
            }           
        }

        return new ResponseEntity<List<ChatMessage>>(messages, HttpStatus.OK);
    }    

    @PostMapping(value = "chat/addChatMessage")
    public ResponseEntity<String> addChatMessage(@RequestBody ChatMessageInfo info) {
        if ( info.SenderUserName == null || info.SenderUserName.isEmpty() )
        {
            return new ResponseEntity<>("No sender username!", HttpStatus.BAD_REQUEST);
        }

        if ( info.ReceiverUserName == null || info.ReceiverUserName.isEmpty() )
        {
            return new ResponseEntity<>("No receiver username!", HttpStatus.BAD_REQUEST);
        }

        ChatMessage message = new ChatMessage();
        message.setSender(userRepository.findByUserName(info.SenderUserName));
        message.setReceiver(userRepository.findByUserName(info.ReceiverUserName));
        message.setType(info.Type);
        message.setContent(info.Content);

        chatMessageRepository.save(message);

        return new ResponseEntity<>(message.getContent(), HttpStatus.OK);
    }   
}
