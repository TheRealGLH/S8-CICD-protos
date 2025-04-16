# Redhat Docker Containers

Originally the C++ build environment Docker image was based on Arch Linux. Because the company uses Redhat Linux (and its package manager) for its internal build enviroments, we concluded that for the proof of concept it was better that our build enviroment uses RH as well.

- ``base-image/`` has a Docker file to create a basic Redhat Linux Docker image.
- ``cpp-build/`` contains the files neccessary for a C++ build environment, similar to the one we made for Arch, but on Red Hat Linux.
