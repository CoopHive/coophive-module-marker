FROM python:3.11

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app

COPY scripts/install/apt-requirements.txt /app/apt-requirements.txt

RUN apt-get update && apt-get install -y $(cat apt-requirements.txt)

RUN apt-get install -y tesseract-ocr

ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

RUN pip install poetry

COPY . /app

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi
