########################################################
#        Renku install section - do not edit           #

FROM renku/renkulab-r:4.3.1-0.24.0 as builder

# RENKU_VERSION determines the version of the renku CLI
# that will be used in this image. To find the latest version,
# visit https://pypi.org/project/renku/#history.
ARG RENKU_VERSION=2.9.2

# Install renku from pypi or from github if a dev version
RUN if [ -n "$RENKU_VERSION" ] ; then \
        source .renku/venv/bin/activate ; \
        currentversion=$(renku --version) ; \
        if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
            pip uninstall renku -y ; \
            gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(rc[[:digit:]]\+\)*\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\4/p") ; \
            if [ -n "$gitversion" ] ; then \
                pip install --no-cache-dir --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
            else \
                pip install --no-cache-dir --force renku==${RENKU_VERSION} ;\
            fi \
        fi \
    fi
#             End Renku install section                #
########################################################

FROM renku/renkulab-r:4.3.1-0.24.0

# Uncomment and adapt if code is to be included in the image
# COPY src /code/src

# Uncomment and adapt if your R or python packages require extra linux (ubuntu) software
# e.g. the following installs apt-utils and vim; each pkg on its own line, all lines
# except for the last end with backslash '\' to continue the RUN line

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    vim \
    libhdf5-dev \
    libncurses5 \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

## install fastq screen
RUN curl -LO http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/fastq_screen_v0.14.0.tar.gz
RUN tar -xzf fastq_screen_v0.14.0.tar.gz && mv fastq_screen_v0.14.0 /opt/ && rm -f fastq_screen_v0.14.0.tar.gz

## install fastqc

RUN curl -LO https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && unzip fastqc_v0.11.9.zip
RUN chmod a+x FastQC/fastqc && mv FastQC /opt/ && rm -f fastqc_v0.11.9.zip

## install fastp
RUN curl -LO http://opengene.org/fastp/fastp && chmod a+x ./fastp && mv ./fastp /opt/

## install kallisto
RUN curl -LO https://github.com/pachterlab/kallisto/releases/download/v0.48.0/kallisto_linux-v0.48.0.tar.gz && tar -xf kallisto_linux-v0.48.0.tar.gz && mv kallisto/kallisto /opt/ && rm -rf ./kallisto kallisto_linux-v0.48.0.tar.gz

## install STAR
RUN curl -LO https://github.com/alexdobin/STAR/archive/2.7.10b.tar.gz && tar -xzf 2.7.10b.tar.gz && cd STAR-2.7.10b && cd source && make && cp STAR /opt/ && cd ../.. && rm -rf ./STAR-2.7.10b

## install seqkit
RUN curl -LO https://github.com/shenwei356/seqkit/releases/download/v2.3.1/seqkit_linux_amd64.tar.gz && tar -zxf seqkit_linux_amd64.tar.gz && mv seqkit /opt/ && rm -f seqkit_linux_amd64.tar.gz

## Set path
ENV PATH=/opt/FastQC:/opt/fastq_screen_v0.14.0:$PATH

USER ${NB_USER}

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# install the python dependencies
RUN pip install -U setuptools wheel
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt --no-cache-dir
RUN git clone https://github.com/MultiQC/MultiQC.git && 
    cd MultiQC && 
    pip install . && 
    cd ..

# install conda dependencies
RUN conda install -y -c bioconda samtools

# install the R dependencies
COPY install.R /tmp/
RUN R -f /tmp/install.R

# Remove venv
RUN rm -rf ${HOME}/.renku/venv

COPY --from=builder ${HOME}/.renku/venv ${HOME}/.renku/venv
