# For finding latest versions of the base image see
# https://github.com/SwissDataScienceCenter/renkulab-docker
ARG RENKU_BASE_IMAGE=renku/renkulab-r:4.2.0-0.13.1
FROM ${RENKU_BASE_IMAGE}

# Uncomment and adapt if code is to be included in the image
# COPY src /code/src

# Uncomment and adapt if your R or python packages require extra linux (ubuntu) software
# e.g. the following installs apt-utils and vim; each pkg on its own line, all lines
# except for the last end with backslash '\' to continue the RUN line
#
USER root
RUN apt-get update && \
   apt-get install -y --no-install-recommends \
   libhdf5-dev \
   libncurses5

## install fastq screen
RUN curl -LO http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/fastq_screen_v0.14.0.tar.gz
RUN tar -xzf fastq_screen_v0.14.0.tar.gz && mv fastq_screen_v0.14.0 /opt/ && rm -f fastq_screen_v0.14.0.tar.gz
## install fastqc
RUN curl -LO https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && unzip fastqc_v0.11.9.zip
RUN chmod a+x FastQC/fastqc && mv FastQC/fastqc /opt/ && rm -rf FastQC fastqc_v0.11.9.zip
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

# install the R dependencies
COPY install.R /tmp/
RUN R -f /tmp/install.R

# install conda dependencies
RUN conda install -y -c bioconda samtools

# install the python dependencies
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

# RENKU_VERSION determines the version of the renku CLI
# that will be used in this image. To find the latest version,
# visit https://pypi.org/project/renku/#history.
ARG RENKU_VERSION=1.10.0

########################################################
# Do not edit this section and do not add anything below

# Install renku from pypi or from github if it's a dev version
RUN if [ -n "$RENKU_VERSION" ] ; then \
        source .renku/venv/bin/activate ; \
        currentversion=$(renku --version) ; \
        if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
            pip uninstall renku -y ; \
            gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(rc[[:digit:]]\+\)*\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\4/p") ; \
            if [ -n "$gitversion" ] ; then \
                pip install --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
            else \
                pip install --force renku==${RENKU_VERSION} ;\
            fi \
        fi \
    fi

########################################################
