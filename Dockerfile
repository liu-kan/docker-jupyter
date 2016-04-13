# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook

MAINTAINER Liu K <liukan@126.com>

USER root

# R pre-requisites
RUN echo "deb http:// ftp.jp.debian.org/debian jessie main contrib non-free\n\
deb-src http:// ftp.jp.debian.org/debian jessie main contrib non-free\n\
deb http:// ftp.jp.debian.org/debian jessie-proposed-updates main contrib non-free\n\
deb-src http:// ftp.jp.debian.org/debian jessie-proposed-updates main contrib non-free\n\
deb http:// ftp.jp.debian.org/debian jessie-updates main contrib non-free\n\
deb-src http:// ftp.jp.debian.org/debian jessie-updates main contrib non-free\n\
deb http://mirrors.ustc.edu.cn/debian-security jessie/updates main\n\
" > /etc/apt/sources.list

RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LC_ALL zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

RUN export LANG=zh_CN.UTF-8 && export LANGUAGE=zh_CN.UTF-8 && dpkg-reconfigure locales
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    openssh-server \
    gcc julia \
    libnettle4 libav-tools inkscape && \
    apt-get clean
# texlive dependencies
RUN apt-get install -y texlive-lang-chinese texlive-lang-cjk texlive-luatex texlive-math-extra texlive-metapost  texlive-plain-extra texlive-science texlive-xetex texlive-bibtex-extra
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

USER jovyan

#RUN conda config --add channels 'https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/' && \
#    conda config --add channels 'https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/' && \
#	conda config --set show_channel_urls yes
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


