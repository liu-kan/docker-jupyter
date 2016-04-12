# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook

MAINTAINER Liu K <liukan@126.com>

USER root

# R pre-requisites
RUN echo "deb http://mirrors.ustc.edu.cn/debian jessie main contrib non-free\n\
deb-src http://mirrors.ustc.edu.cn/debian jessie main contrib non-free\n\
deb http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free\n\
deb-src http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free\n\
deb http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free\n\
deb-src http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free\n\
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
