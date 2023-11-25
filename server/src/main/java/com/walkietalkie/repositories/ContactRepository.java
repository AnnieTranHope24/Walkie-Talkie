package com.walkietalkie.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.walkietalkie.model.Contact;

public interface ContactRepository extends CrudRepository<Contact, Integer> {
    public List<Contact> findByUserId(Integer userId);  
} 