# Pull base image
FROM python:3.10.4-slim-bullseye

# Set environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies

## Install GDAL
RUN apt-get update && \
    apt-get install -y binutils libproj-dev gdal-bin python3-gdal

## Install GEOS
RUN apt-get install -y libgeos-dev

# Set work directory
WORKDIR /code

# Install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Copy project
COPY . .