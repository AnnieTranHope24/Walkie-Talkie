package com.walkietalkie.chat;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ContactPreview {
    private String name;
    private String phoneNumber;
}