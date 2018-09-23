# Source: https://github.com/ufoym/deepo

FROM ubuntu:16.04

RUN rm -rf /var/lib/apt/lists/* \
        /etc/apt/sources.list.d/cuda.list \
        /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
    # Avoid warning "debconf: delaying package configuration, since apt-utils is not installed"
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
# ==================================================================
# tools
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        ca-certificates \
        cmake \
        htop \
        wget \
        curl \
        git \
        vim \
        zip \
        unzip \
        && \
# ==================================================================
# python
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas \
        scikit-learn \
        matplotlib \
        Cython \
        && \
# ==================================================================
# jupyter
# ------------------------------------------------------------------
    $PIP_INSTALL \
        jupyter \
        jupyterlab \
        ipywidgets \
        && \
# ==================================================================
# tensorflow
# ------------------------------------------------------------------
    $PIP_INSTALL \
        tensorflow \
        tensorboard \
        && \
# ==================================================================
# pytorch & fast.ai
# ------------------------------------------------------------------
    $PIP_INSTALL \
        # fastai \
        git+https://github.com/fastai/fastai.git \
        # fast.ai dependecy
        opencv-python \
        # doesn't need this since fast.ai is buit on top of pytorch
        # torch \
        # torchvision \
        tensorboardX  \
        && \
    # fast.ai dependecies
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL libsm6 libxext6 libxrender-dev && \
# ==================================================================
# keras
# ------------------------------------------------------------------
    $PIP_INSTALL \
        h5py \
        keras \
        keras-tqdm \
        livelossplot \
        && \
# ==================================================================
# boosting
# ------------------------------------------------------------------
    $PIP_INSTALL \
        catboost \
        lightgbm \
        xgboost \
        && \
# ==================================================================
# NLP
# ------------------------------------------------------------------
    $PIP_INSTALL \
        nltk \
        spacy \
        pymorphy2 \      
        pymystem3 \
        gensim \
        && \
    # setup nltk
    python3.6 -c "import nltk; nltk.download('stopwords'); nltk.download('punkt')" && \
# ==================================================================
# ML
# ------------------------------------------------------------------
    $PIP_INSTALL \
        fbprophet \
        imgaug \
        kaggle \
        seaborn \
        && \
# ==================================================================
# misc
# ------------------------------------------------------------------
    $PIP_INSTALL \
        stringcase \
        Pillow \    
        requests \        
        scikit-image \
        sympy \           
        tqdm \
        && \
# ==================================================================
# Jupyter lab tweaks
# ------------------------------------------------------------------
    $PIP_INSTALL \
        jupyterlab-git \
        jupyter-tensorboard \
        && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL nodejs && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install @jupyterlab/git && jupyter serverextension enable --py jupyterlab_git && \
    jupyter labextension install jupyterlab_tensorboard && \
    # Fix issue with tqdm_notebook not showing HBox widget
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager
# Copy old user settings
COPY jupyterlab-user-settings.zip .
RUN mkdir -p .jupyter/lab && \
    unzip jupyterlab-user-settings.zip -d .jupyter/lab && \
    rm -rf jupyterlab-user-settings.zip
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

EXPOSE 8888 6006

CMD ["sh", "-c", "jupyter lab --port=9999 --no-browser --ip=0.0.0.0 --allow-root"]
