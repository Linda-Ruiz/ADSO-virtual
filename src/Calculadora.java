import javax.swing.*;
import java.awt.*;

public class Calculadora
{
    //Metodo Sumar//
    public int Sumar(int num1, int num2)
    {
        return num1 + num2;
    }

    //Metodo Restar
    public int Restar(int num1, int num2)
    {
        return num1 - num2;
    }

    //Metodo Multiplicar
    public int Multiplicar(int num1, int num2)
    {
        return num1 * num2;
    }

    //Metodo Dividir
    public double Dividir(double num1, double num2)
    {
        return num1 / num2;
    }

    //psvm

    {
        //Nombreclase nombre objeto = new Nombreclase;x|
        Calculadora calculadora = new Calculadora();
        //Menú para seleccionar alguna opción
        String opcion = JOptionPane.showInputDialog("Seleccione una operación:\n" +
                "1. Sumar\n" +
                "2. Restar\n" +
                "3. Multiplicar\n" +
                "4. Dividir\n" +
                "\nIngrese una opción:");
        int num1 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese  el valor del numero 1"));
        int num2 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese el valor del numero 2"));
        //Se muestra el resultado por consola
        if (opcion.equals("1")) {

            System.out.println("Resultado: " + calculadora.Sumar(num1, num2));

        } else if (opcion.equals("2")) {

            System.out.println("Resultado: " + calculadora.Restar(num1, num2));

        } else if (opcion.equals("3")) {

            System.out.println("Resultado: " + calculadora.Multiplicar(num1, num2));

        } else if (opcion.equals("4")) {

            System.out.println("Resultado: " + calculadora.Dividir(num1, num2));

        } else {

            System.out.println("Opción no válida.");

        }
        //Se muestra el resultado por pantalla
        if (opcion.equals("1")) {

            JOptionPane.showMessageDialog(null, "El resultado de la suma es: " + calculadora.Sumar(num1, num2));

        } else if (opcion.equals("2")) {

            JOptionPane.showMessageDialog(null, "El resultado de la resta es: " + calculadora.Restar(num1, num2));

        } else if (opcion.equals("3")) {

            JOptionPane.showMessageDialog(null, "El resultado de la multiplicación es: " + calculadora.Multiplicar(num1, num2));

        } else if (opcion.equals("4")) {

            JOptionPane.showMessageDialog(null, "El resultado de la división es: " + calculadora.Dividir (num1, num2));

        } else {

            JOptionPane.showMessageDialog(null, "Opción no valida");

        }
    }
}

