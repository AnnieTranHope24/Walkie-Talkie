package com.walkietalkie.services;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.sql.SQLException;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.walkietalkie.ConnectionFactory;
import com.walkietalkie.services.ChatMessageService;

public class ChatMessageServiceTest {
    ConnectionFactory connectionFactory = new ConnectionFactory(System.getenv("USERNAME_392"),
            System.getenv("PASSWORD_392"), "com.microsoft.sqlserver.jdbc.SQLServerDriver", "localhost");
    ChatMessageService chatMessageService;

    @BeforeEach
    void setup(){
        connectionFactory.loadDriver();
        chatMessageService = new ChatMessageService(connectionFactory);
    }    

    @Test
    void getAllMessages() throws SQLException {
        assertEquals(chatMessageService.getAllMessages().size(), 1);
    }
}
