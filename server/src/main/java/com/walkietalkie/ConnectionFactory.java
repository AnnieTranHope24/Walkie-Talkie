package com.walkietalkie;

import java.sql.Connection;
import java.sql.DriverManager;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;

@Service
public class ConnectionFactory {

	@Value("${USERNAME_392}")
	private String username;

	@Value("${PASSWORD_392}")
	private String password;

	@Value("${spring.datasource.driver-class-name}")
	private String driverClass = "";

	@Value("${spring.datasource.url}")
	private String serverUrl;

	private boolean driverFound;

	private String connectionString;

	public ConnectionFactory() {
		
	}

	public ConnectionFactory(String username, String password, String driverClass, String serverUrl) {
		this.username = username;
		this.password = password;
		this.driverClass = driverClass;
		this.serverUrl = serverUrl;
	}

	/**
	 * This method will be called by spring after the construction of a ConnectionFactory instance is 
	 * complete.  In particular, the values of the injected fields serverUrl, driverClass, username, 
	 * and password will have been set from the operating system's environment variables and / or the 
	 * values specified in application.yml
	 */
	@PostConstruct
	public void loadDriver () {
		driverFound = false;
		if (driverClass.equals("")) {
			System.err.println("JDBC driver class not specified; skipping loading driver class".toUpperCase());
			return;
		}

		try {			
			connectionString = String.format(
				"jdbc:sqlserver://%s;user=%s;password=%s;trustServerCertificate=true", 
				serverUrl, username, password);
			Class.forName(driverClass);
			driverFound = true;
			System.err.println(("Successfully loaded JDBC driver: " + driverClass).toUpperCase());
		} catch (ClassNotFoundException e) {
			driverFound = false;
			System.err.println(("Driver class " + driverClass + " is not available on the classpath").toUpperCase());
		}
	}
		

	/**
	 * Creates a java.sql.Connection object that is attached to a database.
	 * 
	 * @return
	 */
	public Connection getConnection() {
		if (!driverFound) {
			throw new RuntimeException("Could not find the JDBC driver (" + driverClass
					+ ").  Please ensure you have the appropriate JAR file on your class path");
		}

		try {
			Connection conn = DriverManager.getConnection(connectionString);
			System.err.println("Succesfully established a connection");
			return conn;
		} catch (Exception e) {
			System.err.println("Unable to connect to database: " + e.getMessage());
			return null;
		}
	}
}
