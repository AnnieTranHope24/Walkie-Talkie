package com.walkietalkie.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.walkietalkie.model.ChatPreview;

public interface ChatPreviewRepository extends CrudRepository<ChatPreview, Integer> {
    public List<ChatPreview> findByUserId(Integer userId);

    public ChatPreview findByUserIdAndContactId(Integer userId, Integer contactId);

    public List<ChatPreview> findByContactId(Integer contactId);

    public List<ChatPreview> findAll();
}
