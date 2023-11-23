package com.walkietalkie.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.walkietalkie.model.ChatMessage;

public interface ChatMessageRepository extends CrudRepository<ChatMessage, Integer>{
    public Optional<ChatMessage> findById(Integer id);

    public List<ChatMessage> findBySenderId(Integer senderId);

    public List<ChatMessage> findByReceiverId(Integer receiverId);

    public List<ChatMessage> findAll();
}
