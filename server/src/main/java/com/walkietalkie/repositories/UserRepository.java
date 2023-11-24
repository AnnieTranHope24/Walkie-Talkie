package com.walkietalkie.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.walkietalkie.model.User;

public interface UserRepository extends CrudRepository<User, Integer> {
    
    public Optional<User> findById(Integer userId);

    public User findByUserName(String username);

    public List<User> findAll();
}
