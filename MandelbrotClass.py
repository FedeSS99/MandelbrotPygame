import pygame as pg
from numpy import uint8, pi, array, zeros, sin, arange
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

    def DibujarArreglo(self, colores, itera, xmin, xmax, ymin, ymax):
        CythonMandelbrot(self.ArrayEspacio, colores, itera, xmin, xmax, ymin, ymax)
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
        self.FactorReal = (self.xmax-self.xmin)/(self.largo-1) 
        self.FactorIma = (self.ymax-self.ymin)/(self.alto-1)

        pg.init()
        self.Ventana = pg.display.set_mode(res, pg.SCALED, 8)
        self.Reloj = pg.time.Clock()
        self.Fractal = MandelbrotFractal(self.Ventana)
        pg.event.set_allowed([pg.QUIT,pg.KEYDOWN,pg.MOUSEWHEEL])
        self.font = pg.font.SysFont('Comic Sans MS', 30)


    def CoordsPlanoVentana(self):
        self.FactorReal = (self.xmax-self.xmin)/(self.largo-1) 
        self.FactorIma = (self.ymax-self.ymin)/(self.alto-1)
        xVentana, yVentana = pg.mouse.get_pos()
        return xVentana, yVentana, xVentana*self.FactorReal, yVentana*self.FactorIma

    def ObtenerRGB(self):
        x=arange(0,self.itera)
        r = 255*(1.0+sin(0.1*x))/2
        g = 255*(1.0+sin(0.1*x+2.094))/2
        b = 255*(1.0+sin(0.1*x+4.188))/2
        return array([r,g,b], dtype=uint8)

    def Correr(self):
        capt = 0
        colores = self.ObtenerRGB()
        while True:
            self.Fractal.DibujarArreglo(colores, self.itera, self.xmin, self.xmax, self.ymin, self.ymax)

            for evento in pg.event.get():
                if evento.type == pg.QUIT:
                    exit()
                elif evento.type == pg.KEYDOWN:
                    if evento.key == pg.K_r:
                        self.xmin, self.xmax, self.ymin, self.ymax = self.RegPos
                    if evento.key == pg.K_UP:
                        self.itera += 50
                        colores = self.ObtenerRGB()
                    if evento.key == pg.K_DOWN:
                        self.itera -= 50
                        colores = self.ObtenerRGB()
                    if evento.key == pg.K_c:
                        pg.image.save(self.Ventana, f"CapturaMandelbrot{capt}.png")
                        capt+=1

                elif evento.type == pg.MOUSEWHEEL:
                    x, y = pg.mouse.get_pos()
                    self.xmin, self.xmax, self.ymin, self.ymax = ZoomInOutConjunto(self.largo, self.alto, x, y, 
                    evento.y, self.xmin, self.xmax, self.ymin, self.ymax)

            if pg.mouse.get_pressed()[0] == True:
                x, y, xPlano, yPlano = self.CoordsPlanoVentana()
                textoCoords = self.font.render(f"({xPlano:1.3e},{yPlano:1.3e})",False,(0,0,0))
                self.Ventana.blit(textoCoords,(x,y))

            pg.display.flip()
            self.Reloj.tick()
            pg.display.set_caption(f"DT: {self.Reloj.get_time()/1000:.3f}s  Iteraciones: {self.itera}  Dims: {self.largo},{self.alto}")
