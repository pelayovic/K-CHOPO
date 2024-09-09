# ----------------------------------------------
# 🌟 K-CHOPO 🌟 
# A hearty and satisfying tool for Nanopore sequencing data analysis!
# Using the base image of ELIGOS2 from DockerHub, we build K-CHOPO
# Maintained by: pelayovic
# ----------------------------------------------

# Usar la imagen de ELIGOS2 desde DockerHub como base
FROM piroonj/eligos2

# ----------------------------------------------
# Cambiar a Ubuntu 22.04 como base para mayor compatibilidad
FROM ubuntu:22.04

# Evitar interacción durante las instalaciones
ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------
# Información del mantenedor del contenedor
LABEL maintainer="pelayovic"





# Install Python 3, pip, and venv for virtual environments
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists/*


# ----------------------------------------------------
# Instalar git y actualizar el sistema
# ----------------------------------------------------
RUN apt-get update && \
    apt-get install -y git

# ----------------------------------------------------
# Crear y establecer el directorio de trabajo
# ----------------------------------------------------
RUN mkdir -p /home
WORKDIR /home

# ----------------------------------------------------
# Instalar paquetes del sistema que puedan ser necesarios
# Estas librerías son fundamentales para compilar paquetes Python y otros sistemas
# ----------------------------------------------------
RUN apt-get install -y \
    build-essential \
    libbz2-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    liblzma-dev \
    libssl-dev \
    libffi-dev \
    bedtools

# ----------------------------------------------------
# Copiar el archivo de requisitos de Python al directorio de trabajo
# ----------------------------------------------------
COPY requirements.txt /home/eligos2/

# ----------------------------------------------------
# Instalar Python 3 y pip
# Eliminar los archivos de caché de apt para reducir el tamaño de la imagen
# ----------------------------------------------------
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------
# Instalar las dependencias de Python desde el archivo requirements.txt
# Esto instala las dependencias necesarias para K-CHOPO sin usar conda
# ----------------------------------------------------
RUN pip3 install --no-cache-dir -r /home/eligos2/requirements.txt

# ----------------------------------------------------
# Instalar R y limpiar el caché de apt
# R es necesario para algunos análisis estadísticos en K-CHOPO
# ----------------------------------------------------
RUN apt-get update && \
    apt-get install -y r-base && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------
# Instalar el paquete R adicional "samplesizeCMH" desde CRAN
# Este paquete es utilizado para cálculos de tamaño de muestra
# ----------------------------------------------------
RUN Rscript -e 'install.packages("samplesizeCMH", repos="https://cloud.r-project.org")'

# ----------------------------------------------------
# Añadir el directorio de eligos2 y su carpeta Scripts al PATH del sistema
# Esto permite que los scripts de K-CHOPO se ejecuten fácilmente desde cualquier lugar
# ----------------------------------------------------
ENV PATH="/home/eligos2:/home/eligos2/Scripts:$PATH"

# ----------------------------------------------------
# Echo para confirmar que la imagen se ha construido correctamente
# ----------------------------------------------------
RUN echo "🌟 K-CHOPO Docker image built successfully! Dive into Nanopore sequencing data analysis! 🧬🍴"

# ----------------------------------------------------
# Comando por defecto al iniciar el contenedor (si es necesario)
# Esto se puede modificar si tienes un script específico que quieres que se ejecute
# ENTRYPOINT ["python3", "/home/eligos2/k_chopo.py"]
# ----------------------------------------------------

