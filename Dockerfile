FROM ubuntu:14.04

RUN apt-get update

RUN apt-get install -y \
	build-essential

RUN apt-get install -y \
	python \
	python3 \
	python-pip \
	python-matplotlib

RUN apt-get install -y \
	python3-dev \
	python3-pip \
	python-dev

RUN pip install \
    jupyter

RUN pip3 install \
    jupyter

# Add kernels for each version of python
RUN ipython kernelspec install-self && \
    ipython3 kernelspec install-self

# Install R
RUN sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" > /etc/apt/sources.list.d/cran.list
# Add cran key to system (may change)
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN sudo apt-get update

RUN apt-get install -y --force-yes \
    r-base \
    r-recommended \
    r-cran-mass \
    r-cran-car \
    r-cran-nlme \
    r-cran-nnet \
    gfortran

COPY stan_options.R /

RUN R -e 'install.packages("ggplot2", dependencies=TRUE, repo="http://cran.rstudio.com/")'
RUN R -f stan_options.R
RUN R -e 'install.packages("rstan", dependencies=TRUE, repo="http://cran.rstudio.com/")'

# Set default CRAN repo
RUN echo 'options("repos"="http://cran.rstudio.com")' >> /usr/lib/R/etc/Rprofile.site

# Install IRkernel
RUN apt-get install -y --force-yes \
    libssl-dev \
    libssh2-1-dev \
    libcurl4-openssl-dev
RUN apt-get install -y --force-yes \
    libzmq3-dev
RUN Rscript -e "install.packages('devtools')" \
    -e "library('devtools'); install_github('armstrtw/rzmq')" \
    -e "install.packages(c('repr','IRkernel','IRdisplay'), repos = c('http://irkernel.github.io/', getOption('repos')))" \
    -e "IRkernel::installspec()"


RUN echo '#!/bin/bash' > /start-notebook.sh && \
     echo 'jupyter notebook --no-browser --ip=*' >> /start-notebook.sh && \
     chmod +x /start-notebook.sh

WORKDIR /home

CMD ["/start-notebook.sh"]
