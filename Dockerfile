# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/datascience-notebook

MAINTAINER Liu K <liukan@126.com>

USER root

# R pre-requisites
RUN echo -e "deb http://mirrors.aliyun.com/debian jessie main contrib non-free\n\
deb-src http://mirrors.aliyun.com/debian jessie main contrib non-free\n\
deb http://mirrors.aliyun.com/debian jessie-proposed-updates main contrib non-free\n\
deb-src http://mirrors.aliyun.com/debian jessie-proposed-updates main contrib non-free\n\
deb http://mirrors.aliyun.com/debian jessie-updates main contrib non-free\n\
deb-src http://mirrors.aliyun.com/debian jessie-updates main contrib non-free\n\
deb http://mirrors.ustc.edu.cn/debian-security jessie/updates main\n\
" > /etc/apt/sources.list

RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LC_ALL zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

RUN export LANG=zh_CN.UTF-8 && export LANGUAGE=zh_CN.UTF-8 && dpkg-reconfigure locales
# texlive dependencies
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    openssh-server \
    libav-tools inkscape \
    texlive-lang-chinese texlive-lang-cjk texlive-luatex texlive-math-extra texlive-metapost  texlive-plain-extra texlive-science texlive-xetex texlive-bibtex-extra \
    latex-cjk-common fonts-lmodern && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#ADD config/ipython_config.py /home/jovyan/.ipython/profile_default/ipython_config.py
ADD config/01-font.py /home/jovyan/.ipython/profile_default/startup/01-font.py

ADD config/jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py
ADD config/article.tplx /opt/conda/lib/python3.5/site-packages/nbconvert/templates/latex/
#ADD config/base.tplx /opt/conda/lib/python3.5/site-packages/nbconvert/templates/latex/
ADD config/ctex-xecjk-winfonts.def /usr/share/texlive/texmf-dist/tex/latex/ctex/fontset/ctex-xecjk-winfonts.def
ADD config/ipython_kernel_config.py /home/jovyan/.ipython/profile_default/ipython_kernel_config.py
ADD fonts/* /home/jovyan/.fonts/
ADD config/custom.js /home/jovyan/.jupyter/custom/
ADD notebook/templates/*.html /opt/conda/lib/python3.5/site-packages/notebook/templates/
RUN  chown -R jovyan /home/jovyan/.ipython ; chgrp -R users /home/jovyan/.ipython; chown -R jovyan /home/jovyan/.fonts ; chgrp -R users /home/jovyan/.fonts; fc-cache -fsv

USER jovyan
#ADD fonts/* /home/jovyan/.fonts/
RUN fc-cache -fsv; fc-list|grep Fandol

    
USER root
ADD logo.png /opt/conda/envs/python2/lib/python2.7/site-packages/notebook/static/base/images/logo.png
ADD logo.png /opt/conda/lib/python3.5/site-packages/notebook/static/base/images/logo.png
ADD logo.png /opt/conda/pkgs/notebook-4.1.0-py35_0/lib/python3.5/site-packages/notebook/static/base/images/logo.png
ADD logo.png /opt/conda/pkgs/notebook-4.1.0-py27_0/lib/python2.7/site-packages/notebook/static/base/images/logo.png
ADD logo.png /opt/conda/logo.png
