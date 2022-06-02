import argparse
from MandelbrotClass import MandelbrotApp

#Resolucion de la ventana y límites del espacio complejo
parser = argparse.ArgumentParser(description="Explorador del conjunto de Mandelbrot")
parser.add_argument("--Nx", type=int, help="Dimensión horizontal del plano")
parser.add_argument("--Ny", type=int, help="Dimensión vertical del plano")

args = parser.parse_args()
if args.Nx is not None:
    Nx = args.Nx
else:
    Nx = 600
if args.Ny is not None:
    Ny = args.Ny
else:
    Ny = 600

resolucion = (Nx,Ny)
xmin, xmax, ymin, ymax = -2.0, 0.5, -1.5, 1.5

#Iniciando ventana
VentanaMain = MandelbrotApp(resolucion, xmin, xmax, ymin, ymax)
VentanaMain.Correr()
