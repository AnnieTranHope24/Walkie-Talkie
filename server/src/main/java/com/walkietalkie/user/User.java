package com.walkietalkie.user;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class User {

    private String username;
    private String name;
    private String password;
    private String phoneNumber;

}
