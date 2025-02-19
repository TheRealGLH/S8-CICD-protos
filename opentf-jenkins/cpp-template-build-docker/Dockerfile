FROM archlinux:latest
RUN useradd -ms /bin/bash builder
RUN pacman -Syu --noconfirm
RUN pacman -S git cmake make gcc clang doxygen python gtest --noconfirm
COPY start-cmake.sh start-cmake.sh
USER builder
ENV PATH="/usr/bin:${PATH}"
ENTRYPOINT ["cmake"]
CMD ["--version"]
