package com.walkietalkie.controllers;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.walkietalkie.model.User;
import com.walkietalkie.repositories.UserRepository;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    private static record UsernameAndPassword(String Username, String Password) {};
    private static record UserInfo(String Username, String Password, String Phonenumber, String Name ) {};
    private static record NameUpdate(String Username, String NewName) {};
    private static record PasswordUpdate(String Username, String NewPassword) {};

    @GetMapping("/user/all")
    ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userRepository.findAll();
        return new ResponseEntity<>(users, HttpStatus.OK);
    }
    
    @PostMapping("/user/check")
    ResponseEntity<String> checkUsernameAndPassword(@RequestBody UsernameAndPassword info ) {
        if ( info.Username == null || info.Username.isEmpty() )
        {
            return new ResponseEntity<>("No username!", HttpStatus.BAD_REQUEST);
        }

        User user = userRepository.findByUserName(info.Username);

        if(user == null) {
            return new ResponseEntity<>("Invalid username!", HttpStatus.BAD_REQUEST);
        }

        if ( info.Password == null || info.Password.isEmpty() )
        {
            return new ResponseEntity<>("No password!", HttpStatus.BAD_REQUEST);
        }

        if(!user.getPassword().equals(info.Password)) {
            return new ResponseEntity<>("Wrong password!", HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity<>("All good!", HttpStatus.OK);
    }

    @PostMapping("/user/create")
    ResponseEntity<String> createUser(@RequestBody UserInfo info ) {
        if ( info.Username == null || info.Username.isEmpty() )
        {
            return new ResponseEntity<>("No username!", HttpStatus.BAD_REQUEST);
        }

        if ( info.Password == null || info.Password.isEmpty() )
        {
            return new ResponseEntity<>("No password!", HttpStatus.BAD_REQUEST);
        }

        if ( info.Phonenumber == null || info.Phonenumber.isEmpty() )
        {
            return new ResponseEntity<>("No phone number!", HttpStatus.BAD_REQUEST);
        }

        if ( info.Name == null || info.Name.isEmpty() )
        {
            return new ResponseEntity<>("No name!", HttpStatus.BAD_REQUEST);
        }

        if ( userRepository.findByUserName(info.Username) != null )
        {
            return new ResponseEntity<>("Username already in use!", HttpStatus.BAD_REQUEST);
        }

        User user = new User(info.Username, info.Name, info.Phonenumber, info.Password);
        user = userRepository.save(user);

        return new ResponseEntity<>("All good!", HttpStatus.OK);
    }

    @PostMapping("/user/changeName")
    ResponseEntity<String> changeUserName( @RequestBody NameUpdate info ) {
        if ( info.Username == null || info.Username.isEmpty() )
        {
            return new ResponseEntity<>("No username!", HttpStatus.BAD_REQUEST);
        }

        if ( info.NewName == null || info.NewName.isEmpty() )
        {
            return new ResponseEntity<>("No name!", HttpStatus.BAD_REQUEST);
        }

        User user = userRepository.findByUserName(info.Username);

        if ( user == null )
        {
            return new ResponseEntity<>("Could not find user!", HttpStatus.BAD_REQUEST);
        }

        if ( user.getName().equals(info.NewName) )
        {
            return new ResponseEntity<>("User Name was the same!", HttpStatus.BAD_REQUEST);
        }

        user.setName(info.NewName);

        user = userRepository.save(user);

        return new ResponseEntity<>("All good!", HttpStatus.OK);
    }

    @PostMapping("/user/changePassword")
    ResponseEntity<String> changeUserPassword( @RequestBody PasswordUpdate info ) {
        if ( info.Username == null || info.Username.isEmpty() )
        {
            return new ResponseEntity<>("No username!", HttpStatus.BAD_REQUEST);
        }

        if ( info.NewPassword == null || info.NewPassword.isEmpty() )
        {
            return new ResponseEntity<>("No password!", HttpStatus.BAD_REQUEST);
        }

        User user = userRepository.findByUserName(info.Username);

        if ( user == null )
        {
            return new ResponseEntity<>("Could not find user!", HttpStatus.BAD_REQUEST);
        }

        if ( user.getPassword().equals(info.NewPassword) )
        {
            return new ResponseEntity<>("User Name was the same!", HttpStatus.BAD_REQUEST);
        }

        user.setPassword(info.NewPassword);

        user = userRepository.save(user);

        return new ResponseEntity<>("All good!", HttpStatus.OK);
    }
}
