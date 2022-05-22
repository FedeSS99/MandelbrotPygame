import pygame as pg
from numpy import uint8, zeros
from RutinaMandelbrot import CythonMandelbrot, ZoomInOutConjunto

class MandelbrotFractal:
    """
    Clase que crea el arreglo de color RGB para exhibir en la ventana display
    de PyGame, además se posee la función DibujarArreglo que estará aplicando
    la función iterativa en el plano complejo bajo la condición de convergencia
    """
    def __init__(self, ventana):
        self.ventana = ventana
        self.largo, self.alto = ventana.get_size()
        self.ArrayEspacio = zeros((self.largo,self.alto,3), dtype=uint8)

    def DibujarArreglo(self,itera, xmin, xmax, ymin, ymax):
        CythonMandelbrot(self.ArrayEspacio, itera, xmin, xmax, ymin, ymax)
        pg.surfarray.blit_array(self.ventana, self.ArrayEspacio)

class MandelbrotApp:
    def __init__(self, res, xmin, xmax, ymin, ymax):
        """
        Clase que crea la ventana de PyGame en la cual se estará mostrando y actualizando
        el estado de cada unos de los puntos del plano complejo dentro de una región delimitada
        por [xmin,xmax]x[ymin,ymax]. Se tienen habilitados determinados los botones flecha arriba
        y abajo para controlar las iteracciones a utilizar y la rueda de ratón para alejar/acercar
        la región a visualizar.
        """
        self.largo, self.alto = res[0], res[1]
        self.itera = 500
        self.RegPos = (xmin, xmax, ymin, ymax)
        self.xmin, self.xmax, self.ymin, self.ymax = xmin, xmax, ymin, ymax

        
        self.Ventana = pg.display.set_mode(res, pg.SCALED, 8)
        self.Reloj = pg.time.Clock()
        self.Fractal = MandelbrotFractal(self.Ventana)
        pg.event.set_allowed([pg.QUIT,pg.KEYDOWN,pg.MOUSEWHEEL])


    def Correr(self):
        while True:
            self.Fractal.DibujarArreglo(self.itera, self.xmin, self.xmax, self.ymin, self.ymax)

            for evento in pg.event.get():
                if evento.type == pg.QUIT:
                    exit()
                elif evento.type == pg.KEYDOWN:
                    if evento.key == pg.K_r:
                        self.xmin, self.xmax, self.ymin, self.ymax = self.RegPos
                    if evento.key == pg.K_UP:
                        self.itera += 50
                    if evento.key == pg.K_DOWN:
                        self.itera -= 50

                elif evento.type == pg.MOUSEWHEEL:
                    x, y = pg.mouse.get_pos()
                    self.xmin, self.xmax, self.ymin, self.ymax = ZoomInOutConjunto(self.largo, self.alto, x, y, 
                    evento.y, self.xmin, self.xmax, self.ymin, self.ymax)


            pg.display.flip()
            self.Reloj.tick()
            pg.display.set_caption(f"FPS: {int(self.Reloj.get_fps()):d}  Iteraciones: {self.itera}")
