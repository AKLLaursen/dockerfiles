FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

LABEL maintainer "Andreas Keller Leth Laursen <anlaursen@deloitte.dk>"

ARG PYTHON_VERSION=3.6
ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USERNAME=anlaursen
ARG USERID=42

# Install basic libraries
RUN apt-get update && \
  apt-get upgrade -y
RUN apt-get install --allow-downgrades --allow-change-held-packages -y build-essential \
  git \
  wget \
  unzip \
  sudo \
  ca-certificates \
  cuda-command-line-tools-9-0 \
  cuda-cublas-9-0 \
  cuda-cufft-9-0 \
  cuda-cudart-dev-9-0 \  
  cuda-curand-9-0 \
  cuda-cusolver-9-0 \
  cuda-cusparse-9-0 \
  libcudnn7=7.1.4.18-1+cuda9.0 \
  libcudnn7-dev=7.1.4.18-1+cuda9.0

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
RUN useradd --create-home -s /bin/bash --no-user-group -u $USERID $USERNAME && \
  chown $USERNAME $CONDA_DIR -R && \
  adduser $USERNAME sudo && \
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to new user
USER $USERNAME
WORKDIR /home/$USERNAME

# Copy preconfigured Jupyter config file
RUN mkdir .jupyter/
COPY jupyter_notebook_config.py .jupyter/

# Install specified Python verion as well as specified libraries 
RUN conda install -y --quiet python=$PYTHON_VERSION
RUN conda install -y --quiet jupyter \
  ipywidgets \
  numpy \ 
  scikit-learn \
  matplotlib \
  pandas \
  sympy \
  pillow \
  scikit-image

RUN conda install -y --quiet -c conda-forge jupyterlab

# Upgrade pip
RUN pip install --upgrade pip

# Install tensorflow and Keras
RUN pip install --upgrade tensorflow-gpu \
  keras

# Install various ML libraries
RUN pip install --upgrade nltk \
  gensim \
  tqdm

# Install PyTorch
RUN conda install -y --quiet pytorch \
  torchvision \
  cuda90 -c pytorch

# Install additional libraries
RUN conda install -y --quiet h5py \
  bcolz \
  boto3 \
  tqdm

RUN pip install --upgrade opencv-python \
  keras-tqdm \
  jupyter_contrib_nbextensions \
  jupyterthemes

RUN conda clean -tipsy

# Setup environment variables
ENV CUDA_HOME=/usr/local/cuda
ENV CUDA_ROOT=$CUDA_HOME
ENV PATH=$PATH:$CUDA_ROOT/bin:$HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib64

# Enable specific Jupyter theme.
RUN jt -t onedork -T -N -f inconsolata -nf robotosans -cellw 95%

# Enable extensions
RUN jupyter contrib nbextension install --user && \
  jupyter nbextension enable codefolding/main && \
  jupyter nbextension enable collapsible_headings/main

# Expose the Jupyter port
EXPOSE 8889
EXPOSE 6607

# Run jupyter lab
CMD jupyter lab
