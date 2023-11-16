package com.walkietalkie.chat;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChatPreview {
    private String name;
    private String message;
    private String timeStamp;
}
