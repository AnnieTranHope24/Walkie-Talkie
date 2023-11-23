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
public class UserService {
    @Autowired
    private ConnectionFactory connectionFactory;

    public UserService(ConnectionFactory connectionFactory) {
        this.connectionFactory = connectionFactory;
    }

    public UserService() {
    
    }   

    public List<String> getAllUsers() throws SQLException {
        ArrayList<String> users = new ArrayList<>();

        try(
			Connection conn = connectionFactory.getConnection();
			Statement stmt = conn.createStatement();
		){
			String sql = "select * from Walkie.Users order by UserId";
			ResultSet results = stmt.executeQuery(sql);

			while(results.next()){
				users.add(results.getString("UserName"));
			}
			
		}

        return users;
    }
}
