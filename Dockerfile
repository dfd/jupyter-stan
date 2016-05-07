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
	python3 \
	python3-dev \
	python3-pip \
	git

RUN pip3 install numpy

RUN pip3 install \
    jupyter \
    cython \
    #numpy \
    pandas \
    seaborn \
    matplotlib

RUN pip3 install -e \
    git+git://github.com/scipy/scipy.git@v0.17.0#egg=scipy-0.17.0

RUN pip3 install \
    scikit-learn 

# Add kernels for each version of python
RUN ipython3 kernelspec install-self

# Install PyStan
RUN pip3 install pystan

ADD start-notebook.sh /start-notebook.sh
RUN chmod +x /start-notebook.sh

WORKDIR /home

CMD ["/start-notebook.sh"]
