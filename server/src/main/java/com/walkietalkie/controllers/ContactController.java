package com.walkietalkie.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.walkietalkie.model.Contact;
import com.walkietalkie.repositories.ContactRepository;
import com.walkietalkie.repositories.UserRepository;

@RestController
@RequestMapping("/api")
public class ContactController {
    @Autowired
    private ContactRepository contactRepository;
    @Autowired
    private UserRepository userRepository;

    private static record ContactFromTo(String UserName) {};
    private static record ContactInfo(String UserName, String ContactName, String ContactPhoneNumber) {};

    @GetMapping(value = "contact/all")
    public ResponseEntity<List<Contact>> getContacts() {
        ArrayList<Contact> contacts = new ArrayList<>();
        for (Contact contact : contactRepository.findAll()) {
            contacts.add(contact);
        }
        return new ResponseEntity<List<Contact>>(contacts, HttpStatus.OK);
    }

    @PostMapping(value = "contact/loadContacts")
    public ResponseEntity<List<Contact>> getContacts(@RequestBody ContactFromTo info) {
        ArrayList<Contact> contacts = new ArrayList<>();
        if(userRepository.findByUserName(info.UserName) == null) return new ResponseEntity<List<Contact>>(contacts, HttpStatus.OK);
        if(contactRepository.findByUserId(userRepository.findByUserName(info.UserName).getId()) == null) return new ResponseEntity<List<Contact>>(contacts, HttpStatus.OK);

        for (Contact contact : contactRepository.findByUserId(userRepository.findByUserName(info.UserName).getId())) {
                contacts.add(contact);
        }

        return new ResponseEntity<List<Contact>>(contacts, HttpStatus.OK);
    }

    @PostMapping(value = "contact/addContact")
    public ResponseEntity<Contact> addContact(@RequestBody ContactInfo contactInfo) {
        if(userRepository.findByPhoneNumber(contactInfo.ContactPhoneNumber) == null) return new ResponseEntity<Contact>(HttpStatus.BAD_REQUEST);

        Contact contact = new Contact();
        contact.setContactName(contactInfo.ContactName);
        contact.setUser(userRepository.findByUserName(contactInfo.UserName));
        contact.setContact(userRepository.findByPhoneNumber(contactInfo.ContactPhoneNumber)); 

        contactRepository.save(contact);
        return new ResponseEntity<Contact>(contact, HttpStatus.OK);
    }
}
