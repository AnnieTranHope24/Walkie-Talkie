package com.walkietalkie.chat;

import java.util.*;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ChatController {

    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/public")
    public ChatMessage sendMessage(
            @Payload ChatMessage chatMessage
    ) {
        return chatMessage;
    }

    @MessageMapping("/chat.addUser")
    @SendTo("/topic/public")
    public ChatMessage addUser(
            @Payload ChatMessage chatMessage,
            SimpMessageHeaderAccessor headerAccessor
    ) {
        headerAccessor.getSessionAttributes().put("username", chatMessage.getSender());
        return chatMessage;
    }

    @PostMapping("/chat/getMessages")
    ResponseEntity<List<ChatMessage>> getMessages(@RequestBody ChatRequest chatRequest ) {
        // List<ChatMessage> msgs = database.getMessages( chatRequest.me, chatRequest.other );
        // List<ChatMessage> msgs2 = database.getMessages( chatRequest.other, chatRequest.me );
        

        List<ChatMessage> msgs = new ArrayList<>();

        msgs.add(new ChatMessage(MessageType.CHAT, "blah", "user1", "user2"));
        msgs.add( new ChatMessage(MessageType.CHAT, "Hello", "user2", "user1"));

        return new ResponseEntity<>(msgs, HttpStatus.OK);
    }

    private static record ChatRequest(String me, String other) { };
}
