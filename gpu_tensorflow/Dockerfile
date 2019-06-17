# Build from a directory containing "jupyter_notebook_config.py" 
# (which is not on a fileshare) with the following command:
#
# docker build -f /shares/dal33/home/$(whoami)/dockerfiles/gpu_tensorflow/Dockerfile -t $(whoami)_tensorflow_2 . \
# --build-arg USERNAME=$(whoami) \
# --build-arg USERID=$UID
#
# Run with the following command:
#
# docker run --runtime=nvidia -v /shares/dal33/home/$(whoami):/home/$(whoami) \
# -p 8891:8891 -p 6009:6009 -it -u $(id -u $USER) $(whoami)_tensorflow_2:latest

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

LABEL maintainer "Andreas Keller Leth Laursen <anlaursen@deloitte.dk>"

ARG PYTHON_VERSION=3.7
ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USERNAME
ARG USERID

# Install basic libraries
RUN apt-get update && \
  apt-get upgrade -y
RUN apt-get install -y build-essential \
  git \
  wget \
  unzip \
  sudo \
  ca-certificates \
  cuda-command-line-tools-10-0 \
  cuda-cublas-10-0 \
  cuda-cufft-10-0 \
  cuda-cudart-dev-10-0 \  
  cuda-curand-10-0 \
  cuda-cusolver-10-0 \
  cuda-cusparse-10-0 \
  libcudnn7=7.5.0.56-1+cuda10.0 \
  libcudnn7-dev=7.5.0.56-1+cuda10.0
  
RUN apt-get update && \
  apt-get install nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda10.0 \
  && apt-get update \
  && apt-get install -y --no-install-recommends libnvinfer-dev=5.0.2-1+cuda10.0

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV PATH $CONDA_DIR/bin:$PATH
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda$CONDA_PYTHON_VERSION-latest-Linux-x86_64.sh -O /tmp/miniconda.sh

RUN echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh
RUN /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR
RUN rm -rf /tmp/* && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Create specified user
RUN useradd -l --create-home -s /bin/bash --no-user-group -u $USERID $USERNAME && \
  chown $USERNAME $CONDA_DIR -R && \
  adduser $USERNAME sudo && \
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Copy preconfigured Jupyter config file
# Note that we change ownership to our user, such that we can actually access the file. The COPY
# command copies as root. COPY has a --chown flag, but it does not accept dynamic user ids.
RUN mkdir /home/$USERNAME/.jupyter/
COPY jupyter_notebook_config.py /home/$USERNAME/.jupyter/
RUN chown $USERNAME /home/$USERNAME/.jupyter/ -R

# Switch to new user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install specified Python verion as well as specified libraries 
RUN conda install -y --quiet python=$PYTHON_VERSION
RUN conda install -y --quiet jupyter \
  ipywidgets \
  numpy \ 
  pandas \
  pillow \
  sympy \
  scikit-learn \
  scikit-image \
  matplotlib \
  h5py \
  bcolz

RUN conda install -y --quiet -c conda-forge altair vega_datasets jupyterlab

# Upgrade pip
RUN pip install --upgrade pip

# Install tensorflow
RUN pip install --upgrade tensorflow-gpu==2.0.0-alpha0 \
  opencv-contrib-python

RUN conda clean -tipsy

# Setup environment variables
ENV CUDA_HOME=/usr/local/cuda
ENV CUDA_ROOT=$CUDA_HOME
ENV PATH=$PATH:$CUDA_ROOT/bin:$HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib64

# Expose the Jupyter port
EXPOSE 8888
EXPOSE 6006

# Run jupyter lab
CMD jupyter lab

