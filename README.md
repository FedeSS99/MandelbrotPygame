# Conjunto-de-Mandelbrot

## Teoría
El conjunto de Mandelbrot se describe como aquel que se define en el espacio complejo bajo la siguiente ecuación:
```diff
 Z_{n+1}=Z_{n}^2 + C
```
donde tendremos que la constante C estará evaluandose en una región de interes bajo la siguiente forma compleja:
```diff
 C = x + i y
```
Este conjunto es altamente sensible a las condiciones iniciales, o dicho de otro modo, al valor de C que se tome; por tanto tendremos casos en que la serie converga a un valor o a una 
serie de valores o bien podrá diverger a infinito. Ahora, como se tratan de números complejos tendremos la necesidad de expresar de forma explicita el cuadrado de un número 
complejo:
```diff
 z = x + i y -> z^2 = x^2-y^2 + 2xy i 
```
La operación se aplicara de forma iterada siguiendo así el comportamiento de convergencia o divergencia.

## Evaluación y visualización del conjunto
Puesto que no es posible calcular infinitas iteraciones de la función generadora se ve la necesidad de fijar una cantidad de iteraciones máxima que delimite la cantidad de 
operaciones que se realicen por pixel en el conjunto por visualizar; siendo que el arreglo que se utilizará para dar con el conjunto consistira en valores localizados entre 0 y 1.
Inicialmente se encuentran todos los elementos con valor de 0 pero al obtener la cantidad de iteraciones de un número complejo fijo tendremos que tener un arreglo de 3 canales de dimension (Nx,Ny) que conformaran los canales de color RGB. Para cada canal se utiliza funciones senoidales
```diff
r = 255*(1.0+sen(0.1*x))/2
g = 255*(1.0+sen(0.1*x+2.094))/2
b = 255*(1.0+sen(0.1*x+4.188))/2
```
## Interacciones con usuario
El entorno utilizado para mostrar el conjunto de Mandelbrot es OpenCV por lo que se asignaron teclas con acciones para manipular las variables que establecen los cálculos del conjunto:
- Flecha arriba: Disminuir cantidad de iteraciones por 50
- Flecha abajo: Aumentar cantidad de iteraciones por 50
- c: Realizar una captura de la ventana y guardar como .png
- r: Reiniciar los valores minimos, maximos a los iniciales

Además de que con la rueda del mouse es posible alejarse/acercarse a una región del conjunto y con click izquierdo es posible
visualizar las coordenadas obtenidas bajo la función iterada.

## Ejemplo 
![alt text](https://github.com/FedeSS99/MandelbrotPygame/blob/master/Ejemplos/CapturaMandelbrot0.png?raw=true)
![alt text](https://github.com/FedeSS99/MandelbrotPygame/blob/master/Ejemplos/CapturaMandelbrot1.png?raw=true)
![alt text](https://github.com/FedeSS99/MandelbrotPygame/blob/master/Ejemplos/CapturaMandelbrot2.png?raw=true)
