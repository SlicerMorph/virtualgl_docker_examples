FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu20.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},graphics,compat32,compute,utility

RUN groupadd -g 1000 docker \
 && useradd -u 1000 -g 1000 -m docker -s /bin/bash \
 && usermod -a -G docker docker

COPY usr/local /usr/local
RUN chmod 755 /usr/local \
 && chmod 755 /usr/local/shared \
 && chmod 755 /usr/local/shared/backgrounds \
 && chmod 644 /usr/local/shared/backgrounds/*
COPY usr/share/applications /usr/share/applications
RUN chmod 755 /usr/share/applications \
 && chmod 644 /usr/share/applications/*

RUN apt -y update 
RUN apt -y upgrade 
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime 
RUN apt install -y gnupg
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt-get -y install software-properties-common
RUN apt-add-repository universe
RUN apt -y update
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+
RUN apt -y update
RUN apt-get install -y sudo
RUN apt-get install -y python3 python3-pip
RUN sudo -H pip3 install setuptools virtualenv keras tensorflow antspyx
RUN apt -y install \
    sudo \
    dbus-x11 \
    emacs-nox \
    firefox \
    git \
    libegl1-mesa \
    libegl1-mesa:i386 \
    libglu1-mesa \
    libglu1-mesa:i386 \
    libnss3 \
    libpulse-mainloop-glib0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0 \
    libxt6 \
    libxt6:i386 \
    libxtst6 \
    libxtst6:i386 \
    libxv1 \
    libxv1:i386 \
    mate-terminal \
    openbox-menu \
    python \
    tint2 \
    vim-common \
    wget \
    x11-utils \
    x11-xkb-utils \
    x11-xserver-utils \
    xauth \
    ssh-client \
    pcmanfm \
    xarchiver \
    libgomp1 \
    gdebi-core \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \ 
    cmake \
    cmake-curses-gui \
    curl \
    r-base \
    r-base-core \
    r-recommended \ 
    r-base-dev \
    r-cran-rgl \
 && wget https://s3.amazonaws.com/virtualgl-pr/dev/linux/virtualgl_2.6.80_amd64.deb \
 && dpkg -i virtualgl*.deb \
 && wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.1093-amd64.deb \
 && gdebi --non-interactive rstu*.deb \
 && rm *.deb \
 && apt install -f \
 && echo 'tint2 &' >>/etc/xdg/openbox/autostart \
 && apt clean \
 && rm -rf /etc/ld.so.cache \
 && rm -rf /var/cache/ldconfig/* \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && rm -rf /var/tmp/* 

COPY install.R .
RUN if [ -f install.R ]; then R --quiet -f install.R; fi
RUN Rscript -e 'remotes::install_version("BGLR")' \
    && Rscript -e 'remotes::install_version("DMwR")' \
    && Rscript -e 'remotes::install_version("FNN")' \
    && Rscript -e 'remotes::install_version("RANN")' \
    && Rscript -e 'remotes::install_version("RGCCA")' \
    && Rscript -e 'remotes::install_version("RcppEigen" )' \
    && Rscript -e 'remotes::install_version("RcppHNSW" )' \
    && Rscript -e 'remotes::install_version("abind" )' \
    && Rscript -e 'remotes::install_version("caret" )' \
    && Rscript -e 'remotes::install_version("corpcor" )' \
    && Rscript -e 'remotes::install_version("dplyr" )' \
    && Rscript -e 'remotes::install_version("e1071" )' \
    && Rscript -e 'remotes::install_version("fastICA" )' \
    && Rscript -e 'remotes::install_version("fpc" )' \
    && Rscript -e 'remotes::install_version("gaston" )' \
    && Rscript -e 'remotes::install_version("geomorph")' \
    && Rscript -e 'remotes::install_version("ggfortify" )' \
    && Rscript -e 'remotes::install_version("ggplot2" )' \
    && Rscript -e 'remotes::install_version("glasso" )' \
    && Rscript -e 'remotes::install_version("gridExtra" )' \
    && Rscript -e 'remotes::install_version("igraph" )' \
    && Rscript -e 'remotes::install_version("irlba" )' \
    && Rscript -e 'remotes::install_version("knitr" )' \
    && Rscript -e 'remotes::install_version("mFilter" )' \
    && Rscript -e 'remotes::install_version("magic" )' \
    && Rscript -e 'remotes::install_version("magrittr" )' \
    && Rscript -e 'remotes::install_version("matlib" )' \
    && Rscript -e 'remotes::install_version("measures" )' \
    && Rscript -e 'remotes::install_version("misc3d" )' \
    && Rscript -e 'remotes::install_version("mnormt" )' \
    && Rscript -e 'remotes::install_version("moments" )' \
    && Rscript -e 'remotes::install_version("mvtnorm" )' \
    && Rscript -e 'remotes::install_version("nabor" )' \
    && Rscript -e 'remotes::install_version("pander" )' \
    && Rscript -e 'remotes::install_version("pbapply" )' \
    && Rscript -e 'remotes::install_version("pheatmap" )' \
    && Rscript -e 'remotes::install_version("pixmap" )' \
    && Rscript -e 'remotes::install_version("plot.matrix" )' \
    && Rscript -e 'remotes::install_version("png" )' \
    && Rscript -e 'remotes::install_version("pracma" )' \
    && Rscript -e 'remotes::install_version("psych" )' \
    && Rscript -e 'remotes::install_version("qlcMatrix" )' \
    && Rscript -e 'remotes::install_version("randomForest" )' \
    && Rscript -e 'remotes::install_version("randomForestExplainer" )' \
    && Rscript -e 'remotes::install_version("rmarkdown")' \
    && Rscript -e 'remotes::install_version("rsvd" )' \
    && Rscript -e 'remotes::install_version("signal" )' \
    && Rscript -e 'remotes::install_version("testthat" )' \
    && Rscript -e 'remotes::install_version("viridis" )' \
    && Rscript -e 'remotes::install_version("visreg" )'

# RUN Rscript -e 'remotes::install_bioc("mixOmics")'
# RUN Rscript -e 'remotes::install_bioc("survcomp")'

RUN Rscript -e 'remotes::install_github( \
        "cran/SpatioTemporal", \
        ref = "3149f4a6ba0359d5b9c1a8fd599ce1bcdb855b1b")' \
    && Rscript -e 'remotes::install_github( \
        "egenn/rtemis", \
        ref = "7e8fe410eb4562dc0915550ffd8f4128d2835d64")'

RUN wget https://github.com/stnava/ITKR/releases/download/v0.5.3.3.0/ITKR_0.5.3.3.0_R_x86_64-pc-linux-gnu_R4.0.tar.gz
RUN wget https://github.com/ANTsX/ANTsRCore/releases/download/v0.7.4.9/ANTsRCore_0.7.4.9_R_x86_64-pc-linux-gnu_R4.0.tar.gz
RUN wget https://github.com/ANTsX/ANTsR/releases/download/v0.5.7.4/ANTsR_0.5.7.4_R_x86_64-pc-linux-gnu_R4.0.tar.gz
RUN R CMD INSTALL ITKR_0.5.3.3.0_R_x86_64-pc-linux-gnu_R4.0.tar.gz
RUN R CMD INSTALL ANTsRCore_0.7.4.9_R_x86_64-pc-linux-gnu_R4.0.tar.gz
RUN R CMD INSTALL ANTsR_0.5.7.4_R_x86_64-pc-linux-gnu_R4.0.tar.gz

RUN perl -i -p0e 's/  <separator \/>\n  <item label=\"Exit\">\n.*\n  <\/item>\n//s' /etc/xdg/openbox/menu.xml
RUN perl -i -p0e 's/  <item label=\"ObConf\">\n[^\n]*\n  <\/item>\n//s' /etc/xdg/openbox/menu.xml
RUN LNUM=$(sed -n '/launcher_item_app/=' /etc/xdg/tint2/tint2rc | head -1) && \
  sed -i "${LNUM}ilauncher_item_app = /usr/share/applications/slicer-vgl.desktop" /etc/xdg/tint2/tint2rc && \
  sed -i "${LNUM}ilauncher_item_app = /usr/share/applications/slicer.desktop" /etc/xdg/tint2/tint2rc && \
  sed -i "/^launcher_item_app = tint2conf\.desktop$/d" /etc/xdg/tint2/tint2rc


RUN wget https://ndownloader.figshare.com/files/28084380?private_link=c9225c4fe14ba0d0e5e7 -O slicer.tgz \
 && tar xzf slicer.tgz -C /home/docker/ \
 && rm slicer.tgz \
 && chown -R 1000:1000 /home/docker/slicer

RUN mkdir -p /home/docker/.config/NA-MIC
COPY ./Slicer.ini /home/docker/.config/NA-MIC/Slicer.ini

RUN mkdir /home/docker/.config/tint2
COPY tint2rc /home/docker/.config/tint2
RUN chown -R 1000.1000 /home/docker/.config

COPY slicer/* /home/docker/slicer/
COPY .Rprofile /home/docker/
RUN chown -R 1000.1000 /home/docker/.Rprofile
USER docker
WORKDIR /home/docker
