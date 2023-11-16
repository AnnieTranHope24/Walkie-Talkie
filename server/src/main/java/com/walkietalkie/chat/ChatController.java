package com.walkietalkie.chat;

import java.util.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ChatController {

    @PostMapping("/chat/getMessages")
    ResponseEntity<List<ChatMessage>> getMessages(@RequestBody ChatRequest chatRequest ) {
        // List<ChatMessage> msgs = database.getMessages( chatRequest.me, chatRequest.other );
        // List<ChatMessage> msgs2 = database.getMessages( chatRequest.other, chatRequest.me );
        

        List<ChatMessage> msgs = new ArrayList<>();

        msgs.add(new ChatMessage(MessageType.CHAT, "blah", "user1", "user2"));
        msgs.add( new ChatMessage(MessageType.CHAT, "Hello", "user2", "user1"));

        return new ResponseEntity<>(msgs, HttpStatus.OK);
    }

    @GetMapping("/chat/loadMessages")
    ResponseEntity<List<ChatPreview>> loadMessages() {
        List<ChatPreview> chatprev = new ArrayList<>();
        chatprev.add(new ChatPreview("John Smith", "Hello...", "Now"));
        chatprev.add(new ChatPreview("Alice Johnson", "How are you?", "1 hour ago"));

        return new ResponseEntity<>(chatprev, HttpStatus.OK);
    }
    private static record ChatRequest(String me, String other) { };
}
