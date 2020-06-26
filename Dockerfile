FROM pulumi/pulumi-python:2.5.0 

LABEL maintainer="Adrian Mowat <adrian.mowat@gmail.com>"

RUN pip install pulumi pulumi_aws && \
    pulumi plugin install resource aws 2.9.1

COPY entrypoint.sh /usr/local/bin/
VOLUME "/code"
WORKDIR "/code"

ENTRYPOINT [ "entrypoint.sh" ]