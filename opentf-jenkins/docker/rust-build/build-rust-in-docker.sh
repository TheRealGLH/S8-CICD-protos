docker run --rm --user "$(id -u)":"$(id -g)" -v "$PWD":/usr/src/steamgriddb-dl -w /usr/src/steamgriddb-dl rust:1.80.0 cargo build --release
