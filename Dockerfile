### Image for the build stage can contain additional dependencies needed to build the application
FROM python:3.9.9 as build-stage

ENV PIP_NO_CACHE_DIR=1
RUN python -m venv /venv
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

## COPY REQUIREMENTS FILE TO DOCKER IMAGE
COPY requirements.txt requirements.txt
RUN pip install --upgrade tables
RUN python -m pip install -U pip
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app
RUN chmod -R 777 /app/

### Sample APP Image builder process
FROM build-stage as sample_app
MAINTAINER Veeresh Kotagi <veeresh.kotagi@ibm.com>

#Label Set
LABEL sample_app.version="2.1-beta"
LABEL sample_app.release-date="2022-02-23"
LABEL sample_app.version.is-production="FALSE"

# Set appver as argument
ARG appver=2.1
# Environment Variables
ENV BACKEND_API_URL='http://localhost'
ENV BACKEND_SVC_URL='http://localhost:8080'
ENV WELCOME_VAR='TEST USER'

# Copy project files to working dir
COPY app.py /app/app.py
COPY templates /app/templates
COPY static /app/static

# Copy Entrypoint inside image
COPY ./entrypoint.sh /app/entrypoint.sh

EXPOSE 5000

#CMD [ "python", "app.py", "run"]
CMD ./entrypoint.sh