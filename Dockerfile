# Usa la imagen base de Ubuntu
FROM ubuntu:latest

# Actualiza los paquetes y configura la zona horaria
RUN apt-get update && apt-get install -y \
    tzdata \
    && cp /usr/share/zoneinfo/America/Santiago /etc/localtime \
    && echo "America/Santiago" > /etc/timezone

# Instala las dependencias mínimas necesarias para compilar Neovim (sin interfaz gráfica)
RUN apt-get install -y \
    bash \
    curl \
    git \
    unzip \
    gcc \
    ripgrep \
    fd-find \
    make \
    python3 \
    python3-pip \
    build-essential \
    tar \
    xz-utils \
    cmake \
    ninja-build \
    gettext \
    libncurses5-dev \
    libssl-dev \
    libvterm-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js (sin NVM)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Clona el repositorio de LazyVim y elimina el directorio .git
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim && \
    rm -rf ~/.config/nvim/.git

# Descargar y descomprimir Neovim v0.10.2
RUN curl -LO https://github.com/neovim/neovim/archive/refs/tags/v0.10.2.zip && \
    unzip v0.10.2.zip && rm v0.10.2.zip

# Cambiar al directorio de Neovim
WORKDIR neovim-0.10.2

# Compilar Neovim
RUN make CMAKE_EXTRA_FLAGS="-DCMAKE_BUILD_TYPE=Release" && make install

# Limpiar los archivos de compilación
RUN make clean

# Volver al directorio anterior
WORKDIR /

# Comando predeterminado
CMD ["bash"]
