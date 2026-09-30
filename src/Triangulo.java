import javax.swing.*;

public class Triangulo
{
     /*
    Desarrolle un metodo que determine si un triangulo es equilatero, es decir, si sus lados son iguales.
    escaleno, es decir, si sus lados son diferentes o rectangulo si dos lados son iguales.
     */

    //metodo triangulo el cual determina el tipo de triangulo
    public void tipoTriangulo(int lado1, int lado2, int lado3)
    {
        if((lado1 == lado2) && (lado2 == lado3))
        {
            JOptionPane.showMessageDialog(null,"Es un triangulo equilatero, ya que todos los lados son iguales");
        }
        else if ((lado1 != lado2) && (lado2 != lado3) && (lado1 != lado3))
        {
            JOptionPane.showMessageDialog(null,"Es un triangulo escaleno, ya que no todos los lados son iguales");
        }
        else
        {
            JOptionPane.showMessageDialog(null,"Es un triangulo rectangulo, ya que dos lados son iguales");
        }
    }

    //psvm
    static void main()
    {
        Triangulo t1 = new Triangulo();
        int lado1 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese el lado 1"));
        int lado2 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese el lado 2"));
        int lado3 = Integer.parseInt(JOptionPane.showInputDialog("Ingrese el lado 3"));
        t1.tipoTriangulo(lado1,lado2,lado3);
    }
}