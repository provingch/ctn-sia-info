/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ctn.informatica.sia.model;

import ctn.informatica.sia.clases.conexion;

/**
 *
 * @author jonat
 */
public class User extends conexion {

    private int id;
    private String username;
    private String fullName;
    private int level;

    public User(int id, String username, String fullName, int level) {
        this.id = id;
        this.username = username;
        this.fullName = fullName;
        this.level = level;
    }

    // getters/setters
    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getFullName() {
        return fullName;
    }

    public int getLevel() {
        return level;
    }

}
