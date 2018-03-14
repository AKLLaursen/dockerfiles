# A Repository for Dockerfiles

This repository is aimed at sharing useful [Dockerfiles](https://docs.docker.com/engine/reference/builder/) internally in AIM as well as Dockerfiles ment to provide runtime environments for internal projects hosted in separate repositories. (`super_resolution` is such an example).

## Docker Files Overview

Below a short description of each Dockerfile hosted in the repository is given.

### `gpu_tensorflow_pytorch`

Builds on [NVidia's official CUDA and CUDNN dockerfile](https://hub.docker.com/r/nvidia/cuda/) (Version 9.0). Provides basic unix libraries such as build-essentials, a Python runtime through [Miniconda](https://conda.io/miniconda.html) with the most general packages for machine learning.

For deep learning, [TensorFlow](https://www.tensorflow.org), [Keras](https://keras.io) and [PyTorch](http://pytorch.org) is provided.

The Dockerfile provides [Jupyter](http://jupyter-notebook.readthedocs.io/en/stable/)  or [Jupyter Lab](http://jupyterlab.readthedocs.io) as well, exposed through port `8888`. Note that Jupyter settings are copied from the `jupyter_notebook_config.py` file, which must be available when building the docker image. The default password for Jupyter is *deloitte*. You should propably change that, by changing the sha1 hashed password in the `jupyter_notebook_config.py` file under `c.NotebookApp.password`. Generate a new hashed password by running:

```python
from notebook.auth import passwd
passwd()
````

Yielding the console output:

````
Enter password:
Verify password:
Out[2]: 'sha1:67c9e60bb8b6:9ffede0825894254b2e042ea597d771089e11aed'
```

The Dockerfile is build to use a GPU(s) and as such it requires [`nvdia-docker`](https://github.com/NVIDIA/nvidia-docker). In initialize.sh commands to set up the bare minimum on a new machine in order to build and run the image is provided. **Remember to reboot your machine after installing the NVidia driver!**

Before building the image, make sure to correct the arguments in the start of the Dockerfile such as Python version and username.

Build an image using eg.

```
docker build -f Dockerfile -t deeplearning .
```

Run the docker image using eg.

```
docker run --runtime=nvidia -v /home/anlaursen/projects:/home/anlaursen/projects -d --rm -p 8888:8888 deeplearning:latest
```

Jupyter will then be accessible from the IP or DNS of the given machine using port 8888 - remember to open that port.

### `cpu_tensorflow_pytorch`

Same as `gpu_tensorflow_pytorch`, but created for usage on the CPU rather than the GPU. As such, the image extends the official Ubuntu 16.04 image and utilizes the CPU version of TensorFlow and PyTorch respectively.

### `super_resolution`

Extends `gpu_tensorflow_pytorch` with the alpha version of [Tesseract 4.0 Alpha](https://github.com/tesseract-ocr/tesseract/wiki/4.0-with-LSTM) (utilizing LSTMs for the character recognition), Microsoft fonts, Pytesseract and the Google Cloud Storage Python API.

## Usefull Docker Commands

In order to avoid using `sudo` to run docker commands, you can add a given user to the docker group as described below.

```
# Add the docker group if it doesn't already exist:
sudo groupadd docker

# Add the connected user "$USER" to the docker group. Change the user name to match your preferred user if you do not want to use your current user:
sudo gpasswd -a $USER docker
``` 

## Contributers

Andreas, <anlaursen@deloitte.dk>
