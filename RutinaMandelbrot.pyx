# cython: language_level = 3

import cython
from cython.parallel cimport prange
from openmp cimport omp_get_max_threads, omp_set_num_threads

import numpy as np
cimport numpy as np

ctypedef np.float64_t Dtype_t
ctypedef np.uint8_t Utype_t


@cython.nonecheck(False)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.profile(False)
cdef CicloParaleloMandelbrot(np.ndarray[Utype_t, ndim=3] Conjunto, np.ndarray[Utype_t, ndim=2] Colores, int MaxIter, Dtype_t xmin, Dtype_t xmax, Dtype_t ymin, Dtype_t ymax):
    cdef:
        int i,j, iteracion, maxThreads
        Dtype_t x, y, x0, y0, xtemp
        Dtype_t r,g,b
        int W = Conjunto.shape[0]
        int H = Conjunto.shape[1]
        Dtype_t FactorReal,FactorIma
    
    maxThreads = <int>omp_get_max_threads()
    omp_set_num_threads(maxThreads)

    FactorReal = (xmax-xmin)/<Dtype_t>(W-1) 
    FactorIma = (ymax-ymin)/<Dtype_t>(H-1) 
    for i in prange(W, nogil=True, num_threads=maxThreads, schedule="dynamic", chunksize=1):
        for j in range(H):
            x = 0.0
            y = 0.0
            x0 = FactorReal*<Dtype_t>i + xmin
            y0 = ymax - FactorIma*<Dtype_t>j
            iteracion = 0
            while iteracion <= MaxIter-1 and x*x + y*y <= 4.0:
                xtemp = x*x - y*y + x0
                y = 2.0*x*y + y0
                x = xtemp
                iteracion = iteracion + 1

            Conjunto[i,j,0] = Colores[0,iteracion]
            Conjunto[i,j,1] = Colores[1,iteracion]
            Conjunto[i,j,2] = Colores[2,iteracion]

@cython.nonecheck(False)
def CythonMandelbrot(np.ndarray[Utype_t, ndim=3] Conjunto, np.ndarray[Utype_t, ndim=2] Colores, int MaxIter, Dtype_t xmin, Dtype_t xmax, Dtype_t ymin, Dtype_t ymax):
    CicloParaleloMandelbrot(Conjunto, Colores, MaxIter, xmin, xmax, ymin, ymax)


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