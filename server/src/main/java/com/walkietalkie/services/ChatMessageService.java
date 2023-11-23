package com.walkietalkie.services;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.walkietalkie.ConnectionFactory;

@Service
public class ChatMessageService {
    @Autowired
    private ConnectionFactory connectionFactory;

    public ChatMessageService(ConnectionFactory connectionFactory) {
        this.connectionFactory = connectionFactory;
    }

    public ChatMessageService() {
    
    }

    public List<String> getAllMessages() throws SQLException {
        ArrayList<String> messages = new ArrayList<>();

        try(
			Connection conn = connectionFactory.getConnection();
			Statement stmt = conn.createStatement();
		){
			String sql = "select * from Walkie.Messages order by MessageId";
			ResultSet results = stmt.executeQuery(sql);

			while(results.next()){
				messages.add(results.getString("Content"));
			}
			
		}

        return messages;
    }
}
