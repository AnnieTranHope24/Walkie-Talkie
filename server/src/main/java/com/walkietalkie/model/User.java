package com.walkietalkie.model;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity 
@Accessors(chain = true)
@Table(name = "Users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    private String userName;
    private String name;
    private String phoneNumber;
    private String password;

    public User(String userName, String name, String phoneNumber, String password) {
        this.userName = userName;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.password = password;
    }
}
