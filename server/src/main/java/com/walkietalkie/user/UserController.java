package com.walkietalkie.user;

import java.util.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class UserController {

    @PostMapping("/user/check")
    ResponseEntity<String> checkUsernameAndPassword(@RequestBody UsernameAndPassword info ) {
        if ( info.Username == null || info.Username.isEmpty() )
        {
            return new ResponseEntity<>("No username!", HttpStatus.BAD_REQUEST);
        }

        if ( info.Password == null || info.Password.isEmpty() )
        {
            return new ResponseEntity<>("No password!", HttpStatus.BAD_REQUEST);
        }

        if ( !info.Username.equals("user1") )
        {
            return new ResponseEntity<>("Invalid username!", HttpStatus.BAD_REQUEST);
        }

        if ( !info.Password.equals("Abcd1234") )
        {
            return new ResponseEntity<>("Invalid password!", HttpStatus.BAD_REQUEST);
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

        if ( info.Username.equals("user1") )
        {
            return new ResponseEntity<>("Username already in use!", HttpStatus.BAD_REQUEST);
        }

        return new ResponseEntity<>("All good!", HttpStatus.OK);
    }

    private static record UsernameAndPassword(String Username, String Password) {};
    private static record UserInfo(String Username, String Password, String Phonenumber, String Name ) {};
}
