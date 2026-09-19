import javax.swing.JOptionPane;

public class Calculadora
{
    // Método Sumar
    public int Sumar(int num1, int num2)
    {
        return num1 + num2;
    }

    // Método Restar
    public int Restar(int num1, int num2)
    {
        return num1 - num2;
    }

    // Método Multiplicar
    public int Multiplicar(int num1, int num2)
    {
        return num1 * num2;
    }

    // Método Dividir
    public double Dividir(double num1, double num2)
    {
        return num1 / num2;
    }

    // Método para determinar el número mayor
    public void esMayor(int num1, int num2)
    {
        if (num1 == num2)
        {
            JOptionPane.showMessageDialog(null,
                    "Los números son iguales");
        }
        else if (num1 > num2)
        {
            JOptionPane.showMessageDialog(null,
                    "Num1 es el mayor");
        }
        else
        {
            JOptionPane.showMessageDialog(null,
                    "Num2 es el mayor");
        }
    }

    // Método para determinar si un número es primo
    public void primo(int num1)
    {
        boolean primo = true;

        for (int i = 2; i < num1; i++)
        {
            if (num1 % i == 0)
            {
                primo = false;
                break;
            }
        }

        if (primo)
        {
            JOptionPane.showMessageDialog(null,
                    "El número es primo");
        }
        else
        {
            JOptionPane.showMessageDialog(null,
                    "El número no es primo");
        }
    }

    // Metodo para determinar el tipo de triangulo

    public void tipoTriangulo(int Lado1, int Lado2, int Lado3)
    {
        if ((Lado1 == Lado2) && (Lado2 == Lado3))
        {
            JOptionPane.showMessageDialog(null,
                    "Es un triángulo equilátero, ya que todos sus lados son iguales");
        }
        else if ((Lado1 != Lado2) &&
                (Lado2 != Lado3) &&
                (Lado1 != Lado3))
        {
            JOptionPane.showMessageDialog(null,
                    "Es un triángulo escaleno, ya que todos sus lados son diferentes");
        }
        else
        {
            JOptionPane.showMessageDialog(null,
                    "Es un triángulo isósceles, ya que dos lados son iguales");
        }
    }

    // Método principal
    public static void main(String[] args)
    {
        // Crear objeto de la clase Calculadora
        Calculadora calculadora = new Calculadora();

        // Menú
        String opcion = JOptionPane.showInputDialog(
                "Seleccione una operación:\n" +
                        "1. Sumar\n" +
                        "2. Restar\n" +
                        "3. Multiplicar\n" +
                        "4. Dividir\n" +
                        "5. Número mayor\n" +
                        "6. Número primo\n" +
                        "7. Tipo de triángulo\n" +
                        "\nIngrese una opción:"
        );

        // Pedir números
        int num1 = Integer.parseInt(
                JOptionPane.showInputDialog(
                        "Ingrese el valor del número 1")
        );

        int num2 = Integer.parseInt(
                JOptionPane.showInputDialog(
                        "Ingrese el valor del número 2")
        );

        // Seleccionar operación
        if (opcion.equals("1"))
        {
            JOptionPane.showMessageDialog(null,
                    "El resultado de la suma es: " +
                            calculadora.Sumar(num1, num2));
        }
        else if (opcion.equals("2"))
        {
            JOptionPane.showMessageDialog(null,
                    "El resultado de la resta es: " +
                            calculadora.Restar(num1, num2));
        }
        else if (opcion.equals("3"))
        {
            JOptionPane.showMessageDialog(null,
                    "El resultado de la multiplicación es: " +
                            calculadora.Multiplicar(num1, num2));
        }
        else if (opcion.equals("4"))
        {
            JOptionPane.showMessageDialog(null,
                    "El resultado de la división es: " +
                            calculadora.Dividir(num1, num2));
        }
        else if (opcion.equals("5"))
        {
            calculadora.esMayor(num1, num2);
        }
        else if (opcion.equals("6"))
        {
            calculadora.primo(num1);
        }
        else if (opcion.equals("7"))
        {
            int lado3 = Integer.parseInt(
                    JOptionPane.showInputDialog(
                            "Ingrese el valor del lado 3")
            );

            calculadora.tipoTriangulo(num1, num2, lado3);
        }
        else
        {
            JOptionPane.showMessageDialog(null,
                    "Opción no válida");
        }
    }
}


