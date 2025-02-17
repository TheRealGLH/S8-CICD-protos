FROM archlinux:latest
RUN useradd -ms /bin/bash builder
RUN pacman -Syu --noconfirm
RUN pacman -S git cmake make gcc clang doxygen python gtest --noconfirm
USER builder
ENV PATH="/usr/bin:${PATH}"
ENTRYPOINT ["/bin/bash", "-l", "-c"]
#CMD ["bash"]
