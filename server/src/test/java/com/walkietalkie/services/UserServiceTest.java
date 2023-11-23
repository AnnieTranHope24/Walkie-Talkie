package com.walkietalkie.services;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.sql.SQLException;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.walkietalkie.ConnectionFactory;

public class UserServiceTest {
    ConnectionFactory connectionFactory = new ConnectionFactory(System.getenv("USERNAME_392"),
            System.getenv("PASSWORD_392"), "com.microsoft.sqlserver.jdbc.SQLServerDriver", "localhost");
    UserService userService;

    @BeforeEach
    void setup(){
        connectionFactory.loadDriver();
        userService = new UserService(connectionFactory);
    }
    @Test
    void getAllUsers() throws SQLException {
        List<String> actual = userService.getAllUsers();

        assertEquals(actual.size(), 1);
    }
}
