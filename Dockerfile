FROM nvcr.io/nvidia/cuda:13.0.1-devel-ubuntu24.04

ARG CHATTERBOX_REF=59bc590b3cad826e5d5987745bf6844627a21ad5

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_PREFER_BINARY=1
ENV PORT=7860

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ffmpeg libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/miniforge.sh \
      https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm -f /tmp/miniforge.sh

ENV PATH="/opt/conda/envs/chatterbox/bin:/opt/conda/bin:${PATH}"

RUN conda create -y -n chatterbox python=3.11 pip && \
    conda clean -afy

RUN pip install --no-cache-dir --upgrade pip "setuptools<81" wheel && \
    pip install --no-cache-dir \
      torch==2.9.1 \
      torchvision==0.24.1 \
      torchaudio==2.9.1 \
      --index-url https://download.pytorch.org/whl/cu130 && \
    pip install --no-cache-dir \
      numpy==1.25.2 \
      librosa==0.11.0 \
      s3tokenizer==0.2.0 \
      transformers==4.46.3 \
      diffusers==0.29.0 \
      resemble-perth==1.0.1 \
      conformer==0.3.2 \
      safetensors==0.5.3 \
      spacy-pkuseg==1.0.1 \
      pykakasi==2.3.0 \
      gradio==5.44.1 \
      pyloudnorm \
      omegaconf \
      soundfile==0.13.1 \
      "huggingface_hub[hf_xet]==0.36.0"

RUN git clone https://github.com/resemble-ai/chatterbox.git /opt/chatterbox && \
    cd /opt/chatterbox && \
    git checkout "${CHATTERBOX_REF}" && \
    pip install --no-cache-dir -e . --no-deps

COPY launch.py /opt/launch.py

WORKDIR /opt/chatterbox

EXPOSE 7860

CMD ["python", "/opt/launch.py"]
