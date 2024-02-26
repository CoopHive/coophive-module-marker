FROM python:3.11 AS builder

WORKDIR /build

COPY scripts/install/apt-requirements.txt /build/apt-requirements.txt

RUN apt-get update \
    && apt-get install -y $(cat apt-requirements.txt) \
    && apt-get install -y tesseract-ocr

FROM python:3.11

ARG HUGGINGFACE_TOKEN

WORKDIR /app

COPY --from=builder /usr/share/tesseract-ocr /usr/share/tesseract-ocr

ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata
ENV PIP_DEFAULT_TIMEOUT=10000

RUN pip install poetry

COPY . /app

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && apt-get install -y python3 python3-pip git libgl1-mesa-glx libglib2.0-0 && \
    pip3 install huggingface_hub==0.16.4 && \
    huggingface-cli login --token $HUGGINGFACE_TOKEN && \
    rm /root/.cache/huggingface/token

RUN poetry config virtualenvs.create false 
RUN poetry install --no-interaction --no-ansi

# # poetry install getting killed by OOM

# RUN mkdir /swap && \
#     dd if=/dev/zero of=/swap/swapfile1 bs=1M count=2048 && \
#     mkswap /swap/swapfile1 && \
#     chmod 600 /swap/swapfile1 

# RUN /swap/swapfile1 swap swap defaults 0 0

RUN mkdir -p /inputs 
RUN mkdir -p /outputs
RUN cp ./data/example.pdf  /inputs/


# trick to install hf models
# RUN poetry run python convert_single.py /app/data/example.pdf /outputs/UniversalBoincCredit01-01-2022.md --parallel_factor 2 --max_pages 10
# TODO: Vardhan move it to builder 
RUN poetry run python ./marker/models.py
# TODO: Vardhan check if this file will download all models or download based on condition, if yes then you need to write a separate function that will download all models necessary


ENV HF_DATASETS_OFFLINE=1 
ENV TRANSFORMERS_OFFLINE=1 

# ENTRYPOINT [ "poetry","run", "python", "convert_single.py" ] #conflicting with bacalhau 
# CMD ["/inputs/example.pdf", "/outputs/output.md", "--parallel_factor 1" ,"--max_pages 10"]