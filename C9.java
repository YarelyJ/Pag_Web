package com.tesji.formulariotda;
import javax.swing.JOptionPane;
public class C9 {
    public static void main(String[] args) {
        int num1 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese el primer número:"));
        int num2 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese el segundo número:"));
        if (num1 != num2) {
            JOptionPane.showMessageDialog(null, "El mayor es: " + Math.max(num1, num2));
        } else {
            JOptionPane.showMessageDialog(null, "Los números son iguales.");
        }
    }
}
