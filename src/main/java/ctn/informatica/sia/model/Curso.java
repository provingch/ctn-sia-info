/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ctn.informatica.sia.model;

/**
 *
 * @author jonat
 */
public class Curso {

    private int id;
    private String especialidad;
    private int promocion;
    private String seccion;
    private int period = 2025; // TODO add functionality later

    public Curso(int id, String especialidad, int promocion, String seccion) {
        this.id = id;
        this.especialidad = especialidad;
        this.promocion = promocion;
        this.seccion = seccion;
    }

    public int getCurso() {
        return period - promocion + 3;
    }
    
    public String getCursoOrdinal() {
        int cursoInt = period - promocion + 3;
        return switch (cursoInt) {
            case 1 -> "Primero";
            case 2 -> "Segundo";
            case 3 -> "Tercero";
            default -> "Desconocido";
        };
    }

    @Override
    public String toString() {
        return especialidad + " " + getCursoOrdinal() + " Sección: " + seccion;
    }

    public int getId() {
        return id;
    }

    // getters
    public String getEspecialidad() {
        return especialidad;
    }

    public int getPromocion() {
        return promocion;
    }

    public String getSeccion() {
        return seccion;
    }

    public int getPeriod() {
        return period;
    }

}
