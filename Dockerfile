# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

USER root

# R pre-requisites
RUN echo "deb http://mirrors.aliyun.com/debian jessie main\n\
deb-src http://mirrors.aliyun.com/debian jessie main\n\
deb http://mirrors.aliyun.com/debian jessie-updates main\n\
deb-src http://mirrors.aliyun.com/debian jessie-updates main\n\
deb http://security.debian.org jessie/updates main\n\
deb-src http://security.debian.org jessie/updates main\n\
" > /etc/apt/sources.list

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    openssh-server \
    gcc julia \
    libnettle4 libav-tools && \
    apt-get clean
# Julia dependencies
#RUN apt-get install -y --no-install-recommends \
#    julia \
#    libnettle4 

# libav-tools for matplotlib anim
#RUN apt-get install -y --no-install-recommends libav-tools && \
#    apt-get clean

USER jovyan

# Install Python 3 packages
RUN conda install --yes \
    'ipywidgets=4.1*' \
    'pandas=0.17*' \
    'matplotlib=1.5*' \
    'scipy=0.17*' \
    'seaborn=0.7*' \
    'scikit-learn=0.17*' \
    'scikit-image=0.11*' \
    'sympy=0.7*' \
    'cython=0.23*' \
    'patsy=0.4*' \
    'statsmodels=0.6*' \
    'cloudpickle=0.1*' \
    'dill=0.2*' \
    'numba=0.23*' \
    'bokeh=0.11*' \
    'h5py=2.5*' \
    && conda clean -tipsy

# Install Python 2 packages
RUN conda create --yes -p $CONDA_DIR/envs/python2 python=2.7 \
    'ipython=4.1*' \
    'ipywidgets=4.1*' \
    'pandas=0.17*' \
    'matplotlib=1.5*' \
    'scipy=0.17*' \
    'seaborn=0.7*' \
    'scikit-learn=0.17*' \
    'scikit-image=0.11*' \
    'sympy=0.7*' \
    'cython=0.23*' \
    'patsy=0.4*' \
    'statsmodels=0.6*' \
    'cloudpickle=0.1*' \
    'dill=0.2*' \
    'numba=0.23*' \
    'bokeh=0.11*' \
    'h5py=2.5*' \
    'pyzmq' \
    && conda clean -tipsy

# R packages including IRKernel which gets installed globally.
RUN conda config --add channels r
RUN conda install --yes \
    'rpy2=2.7*' \
    'r-base=3.2*' \
    'r-irkernel=0.5*' \
    'r-plyr=1.8*' \
    'r-devtools=1.9*' \
    'r-dplyr=0.4*' \
    'r-ggplot2=1.0*' \
    'r-tidyr=0.3*' \
    'r-shiny=0.12*' \
    'r-rmarkdown=0.8*' \
    'r-forecast=5.8*' \
    'r-stringr=0.6*' \
    'r-rsqlite=1.0*' \
    'r-reshape2=1.4*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-randomforest=4.6*' && conda clean -tipsy

# Install IJulia packages as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'Pkg.add("IJulia")' && \
    mv /home/$NB_USER/.local/share/jupyter/kernels/* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf /home/$NB_USER/.local/share
RUN julia -e 'Pkg.add("Gadfly")' && julia -e 'Pkg.add("RDatasets")'

USER root
ADD config/sshd_config /etc/ssh/sshd_config
RUN systemctl enable ssh && service ssh restart
# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime.
RUN $CONDA_DIR/envs/python2/bin/python \
    $CONDA_DIR/envs/python2/bin/ipython \
    kernelspec install-self
EXPOSE 8888
# Switch back to jovyan to avoid accidental container runs as root
USER jovyan
ADD config/ipython_config.py /home/jovyan/.ipython/profile_default/ipython_config.py
ADD config/ipython_kernel_config.py /home/jovyan/.ipython/profile_default/ipython_kernel_config.py

USER root
