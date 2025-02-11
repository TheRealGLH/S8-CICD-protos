FROM jenkins/jenkins:lts-jdk17
# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y ruby make wget
# Download and extract OpenTofu binaries
ARG OPENTOFU_VERSION=1.9.0
RUN wget -O opentofu.tar.gz https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz \
    && tar -xzf opentofu.tar.gz \
    && mv tofu /usr/local/tofu \
    && rm opentofu.tar.gz

# drop back to the regular jenkins user - good practice
USER jenkins
ENV PATH="/usr/local:${PATH}"
#RUN whereis tofu
#RUN tofu -v
