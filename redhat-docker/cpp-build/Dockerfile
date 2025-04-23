FROM registry.access.redhat.com/ubi8/ubi:8.1
# Raven repository which contains extra packages
RUN dnf --assumeyes install https://pkgs.sysadmins.ws/el8/base/x86_64/raven-release.el8.noarch.rpm;
# The powertools repo cannot be added without a RedHat subscription, so we have to install this dependency manually
RUN dnf --assumeyes install https://repo.almalinux.org/almalinux/8/PowerTools/x86_64/os/Packages/doxygen-1.8.14-12.el8.x86_64.rpm;
# Now we install all of our remaining packages
RUN yum -y install gcc-8.5.0-26.el8_10.x86_64 cmake-3.26.5-2.el8 git-2.43.5-2.el8_10 make-1:4.2.1-11.el8 gtest-1.13.0-3.el8 
#clang-libs-18.1.8-1.el8.x86_64

ENTRYPOINT ["cmake"]
CMD ["--version"]

