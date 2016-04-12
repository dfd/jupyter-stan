FROM debian:jessie
MAINTAINER Patrick Callier <pcallier@lab41.org>

RUN apt-get update

RUN apt-get install -yq --force-yes \
	build-essential \
	gfortran \
	pkg-config \
	libatlas-base-dev \
 	libfreetype6-dev

RUN apt-get install -yq \
	python \
	python3 \
	python-pip \
	python3-dev \
	python3-pip \
	python-dev \
	git

RUN pip install \
    jupyter \
    cython \
    numpy \
    pandas \
    seaborn \
    matplotlib

RUN pip install -e \
    git+git://github.com/scipy/scipy.git@v0.17.0#egg=scipy-0.17.0

RUN pip install \
    scikit-learn 

RUN pip3 install \
    jupyter \
    cython \
    numpy \
    pandas \
    seaborn \
    matplotlib

RUN pip3 install -e \
    git+git://github.com/scipy/scipy.git@v0.17.0#egg=scipy-0.17.0

RUN pip3 install \
    scikit-learn 

# Add kernels for each version of python
RUN ipython kernelspec install-self && \
    ipython3 kernelspec install-self

# Install R
RUN echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list
# Add cran key to system (may change)
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480

RUN apt-get update

RUN apt-get install -yq --force-yes \
    r-base \
    r-recommended \
    r-cran-mass \
    r-cran-car \
    r-cran-nlme \
    r-cran-nnet

COPY stan_options.R /

RUN R -e 'install.packages("ggplot2", dependencies=TRUE, repo="http://cran.rstudio.com/")'
RUN R -f stan_options.R
RUN R -e 'install.packages("rstan", dependencies=TRUE, repo="http://cran.rstudio.com/")'

# Set default CRAN repo
RUN echo 'options("repos"="http://cran.rstudio.com")' >> /usr/lib/R/etc/Rprofile.site

# Install IRkernel
RUN apt-get install -yq --force-yes \
    libssl-dev \
    libssh2-1-dev \
    libcurl4-openssl-dev
RUN apt-get install -yq --force-yes \
    libzmq3-dev
RUN Rscript -e "install.packages('devtools')" \
    -e "library('devtools'); install_github('armstrtw/rzmq')" \
    -e "install.packages(c('repr','IRkernel','IRdisplay'), repos = c('http://irkernel.github.io/', getOption('repos')))" \
    -e "IRkernel::installspec()"

RUN pip install pystan && \
    pip3 install pystan

RUN echo '#!/bin/bash' > /start-notebook.sh && \
     echo 'jupyter notebook --no-browser --ip=*' >> /start-notebook.sh && \
     chmod +x /start-notebook.sh

WORKDIR /home

CMD ["/start-notebook.sh"]
