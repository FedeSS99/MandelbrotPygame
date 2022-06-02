# cython: language_level = 3

import cython
from cython.parallel cimport prange
from openmp cimport omp_get_max_threads, omp_set_num_threads

from pygame.draw import line
import numpy as np
cimport numpy as np

ctypedef np.float64_t Dtype_t
ctypedef np.uint32_t UIntType_t
ctypedef np.uint8_t Utype_t


@cython.nonecheck(False)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.profile(False)
cdef CicloParaleloMandelbrot(np.ndarray[Utype_t, ndim=3] Conjunto, np.ndarray[Utype_t, ndim=2] Colores, int MaxIter, Dtype_t xmin, Dtype_t xmax, Dtype_t ymin, Dtype_t ymax):
    cdef:
        int i,j, iteracion, maxThreads
        Dtype_t x, y, cx, cy, xtemp
        Dtype_t r,g,b
        int W = Conjunto.shape[0]
        int H = Conjunto.shape[1]
        Dtype_t FactorReal,FactorIma
        int LimMax = MaxIter - 1
    
    maxThreads = <int>omp_get_max_threads()
    omp_set_num_threads(maxThreads)

    FactorReal = (xmax-xmin)/<Dtype_t>(W-1) 
    FactorIma = (ymax-ymin)/<Dtype_t>(H-1) 
    for i in prange(W, nogil=True, num_threads=maxThreads, schedule="dynamic", chunksize=1):
        for j in range(H):
            x = 0.0
            y = 0.0
            cx = FactorReal*<Dtype_t>i + xmin
            cy = ymax - FactorIma*<Dtype_t>j
            iteracion = 1
            while iteracion <= LimMax-1  and x*x + y*y <= 4.0:
                xtemp = x*x - y*y + cx
                y = 2.0*x*y + cy
                x = xtemp
                iteracion = iteracion + 1

            if iteracion < LimMax:
                Conjunto[i,j,0] = Colores[0,iteracion]
                Conjunto[i,j,1] = Colores[1,iteracion]
                Conjunto[i,j,2] = Colores[2,iteracion]
            
            

@cython.nonecheck(False)
def CythonMandelbrot(np.ndarray[Utype_t, ndim=3] Conjunto, np.ndarray[Utype_t, ndim=2] Colores, int MaxIter, Dtype_t xmin, Dtype_t xmax, Dtype_t ymin, Dtype_t ymax):
    CicloParaleloMandelbrot(Conjunto, Colores, MaxIter, xmin, xmax, ymin, ymax)

@cython.nonecheck(False)
@cython.cdivision(True)
def DibujarTrayectoria(int xM, int yM, Dtype_t FactorReal, Dtype_t FactorIma, int MaxIter, Dtype_t xmin, Dtype_t xmax, Dtype_t ymin, Dtype_t ymax, Ventana):
    cdef:
        Dtype_t x = 0.0
        Dtype_t y = 0.0
        Dtype_t xtemp
        UIntType_t xT, yT
        Dtype_t cx = FactorReal*<Dtype_t>xM + xmin
        Dtype_t cy = ymax - FactorIma*<Dtype_t>yM
        int iteracion = 1
        int LimMax = MaxIter - 1
        UIntType_t x0,y0, x1,y1

    x0 = xM
    y0 = yM

    while iteracion <= LimMax-1  and x*x + y*y <= 4.0:
        iteracion = iteracion + 1
        xtemp = x*x - y*y + cx
        y = 2.0*x*y + cy
        x = xtemp
        x1 = <UIntType_t> ((x - xmin)/FactorReal)
        y1 = <UIntType_t> ((ymax - y)/FactorIma)
        line(Ventana, (0,0,255), (x0, y0), (x1,y1))
        x0 = x1
        y0 = y1

cdef Dtype_t InterpolacionLineal(Dtype_t inicio, Dtype_t final, Dtype_t tasa):
    cdef:
        Dtype_t resultado
    resultado = inicio + tasa*(final-inicio)
    return resultado

@cython.nonecheck(False)
@cython.cdivision(True)
@cython.profile(False)
def ZoomInOutConjunto(int Nx, int Ny, int x, int y, int evento, Dtype_t xmin, Dtype_t xmax, Dtype_t ymin, Dtype_t ymax):
    cdef:
        Dtype_t x0, y0
        Dtype_t FactorReal,FactorIma,escalaIn,escalaOut

    FactorReal, FactorIma = (xmax-xmin)/<Dtype_t>(Nx-1), (ymax-ymin)/<Dtype_t>(Ny-1) 
    x0, y0 = FactorReal*<Dtype_t>x + xmin, ymax - FactorIma*<Dtype_t>y
    escalaIn = 0.95
    escalaOut = 1/escalaIn

    if evento == 1:
        xmin = InterpolacionLineal(x0, xmin, escalaIn)
        ymin = InterpolacionLineal(y0, ymin, escalaIn)
        xmax = InterpolacionLineal(x0, xmax, escalaIn)
        ymax = InterpolacionLineal(y0, ymax, escalaIn)
    elif evento == -1:
        xmin = InterpolacionLineal(x0, xmin, escalaOut)
        ymin = InterpolacionLineal(y0, ymin, escalaOut)
        xmax = InterpolacionLineal(x0, xmax, escalaOut)
        ymax = InterpolacionLineal(y0, ymax, escalaOut)
    
    return xmin, xmax, ymin, ymax
