# Baseline
``docker-compose.yml`` has the following services:
- Bitbucket
- Postgress instance for Bitbucket
- Jenkins
- SVN server

This was ultimately abandoned because of issues related to the interconnectivity between Bitbucket and Jenkins having unresolvable issues if they were running in the same Docker network.

The two sub directories in ``helm/`` were for trying to get a basic project running in with Helm. This approach was discarded in favour of Terraform/ Tofu and thus left unfinished.
