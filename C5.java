package com.tesji.formulariotda;

import javax.swing.*;

public class C5 {
    public static void main (String [] args) {
    int suma = 0;
    for (int i=1; i<=4; i++){
        suma+=Integer.parseInt(JOptionPane.showInputDialog("Ingresa los numeros"));
    }
    byte prom= (byte) (suma/4);
        JOptionPane.showMessageDialog(null, "Suma: " +  suma + "Promedio: " + prom);
    }
}
