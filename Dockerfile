FROM pulumi/pulumi-python:2.4.0 

LABEL maintainer="Adrian Mowat <adrian.mowat@gmail.com>"

COPY entrypoint.sh /usr/local/bin/

VOLUME "/code"

WORKDIR "/code"

ENTRYPOINT [ "entrypoint.sh" ]