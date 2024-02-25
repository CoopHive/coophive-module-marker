FROM python:3.11 AS builder

WORKDIR /build

COPY scripts/install/apt-requirements.txt /build/apt-requirements.txt

RUN apt-get update \
    && apt-get install -y $(cat apt-requirements.txt) \
    && apt-get install -y tesseract-ocr

FROM python:3.11

WORKDIR /app

COPY --from=builder /usr/share/tesseract-ocr /usr/share/tesseract-ocr

ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

RUN pip install poetry

COPY . /app

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi


# TODO: ENTRYPOINT