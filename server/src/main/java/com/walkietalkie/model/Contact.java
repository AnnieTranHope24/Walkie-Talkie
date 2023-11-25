package com.walkietalkie.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@Data
@NoArgsConstructor
@Entity 
@Accessors(chain = true)
@Table(name = "Contacts")
public class Contact {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @SequenceGenerator(name="contact_generator", sequenceName = "contact_seq")
    private Integer id;  
    @ManyToOne
    @JoinColumn(name = "userId")
    private User user;    
    @ManyToOne
    @JoinColumn(name = "contactId")
    private User contact;
    private String contactName; //Name that the user has given to the contact
}
