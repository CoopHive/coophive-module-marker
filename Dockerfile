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

RUN pip install poetry

COPY . /app

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && apt-get install -y python3 python3-pip git libgl1-mesa-glx libglib2.0-0 && \
    pip3 install huggingface_hub==0.16.4 && \
    huggingface-cli login --token $HUGGINGFACE_TOKEN && \
    rm /root/.cache/huggingface/token

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi


RUN mkdir -p /inputs
COPY a.pdf /inputs/


# run to install hf models
RUN poetry run python convert_single.py /app/a.pdf /app/data.md --parallel_factor 2 --max_pages 10


ENTRYPOINT [ "poetry","run", "python", "convert_single.py" ]
CMD ["/inputs/a.pdf", "/outputs/data.md", "--parallel_factor 1" ,"--max_pages 10"]