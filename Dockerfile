# Adds Python to existing Hashicorp Docker container.
# https://hub.docker.com/layers/hashicorp/terraform/1.3.7/images/sha256-48dbb8ae5b0d0fa63424e2eedffd92751ed8d0f2640db4e1dcaa7efc0771dc41?context=explore
# https://github.com/docker-library/python/blob/master/Dockerfile-linux.template

FROM hashicorp/terraform:1.3.7

ENV PATH /usr/local/bin:$PATH:$GOPATH
ENV LANG C.UTF-8
ENV GOOGLE_APPLICATION_CREDENTIALS /tmp/gcp.json

RUN apk add --no-cache python3 py3-pip

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

WORKDIR /tmp
ENTRYPOINT ["terraform"]