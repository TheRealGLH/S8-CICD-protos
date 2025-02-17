docker run --rm --user "$(id -u)":"$(id -g)" -v "$PWD":/usr/src/project -w /usr/src/project martijnd95/cpp-build:latest "cmake . -B build"
