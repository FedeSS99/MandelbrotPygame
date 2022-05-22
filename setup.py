from numpy.lib.utils import get_include
from setuptools import Extension, setup
from Cython.Build import cythonize

moduloExt = [Extension(
    "RutinaMandelbrot",
    ["RutinaMandelbrot.pyx"],
    extra_compile_args=["-ffast-math","-O3","-march=native","-fopenmp"],
    extra_link_args=["-fopenmp"]
)]

setup(
    name="RutinaMandelbrot",
    ext_modules=cythonize(moduloExt, annotate=True),
    include_dirs=[get_include()],
    zip_safe=False
)
