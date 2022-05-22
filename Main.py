from MandelbrotClass import MandelbrotApp

#Resolucion de la ventana y límites del espacio complejo
resolucion = (700,700)
xmin, xmax, ymin, ymax = -2.0, 2.0, -2.0, 2.0

#Iniciando ventana
VentanaMain = MandelbrotApp(resolucion, xmin, xmax, ymin, ymax)
VentanaMain.Correr()