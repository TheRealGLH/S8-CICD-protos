FROM ubuntu:latest

USER root
#if we kept our own package repository, we could specify a version of cargo to use too. this would obviously extend to other tools
RUN apt-get update && apt-get install -y cargo
ENV PATH="/usr/bin:${PATH}"


ENTRYPOINT ["cargo"]
CMD ["-V"]
