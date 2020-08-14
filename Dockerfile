# 🎥 PDS LDD Generation Action
# ===============================

# Container image that runs your code
FROM ubuntu:18.04


# Metadata
# --------

LABEL "com.github.actions.name"="PDS LDD Generation"
LABEL "com.github.actions.description"="Generated PDS4 Local Data Dictionaries from IngestLDDs with LDDTool"
LABEL "com.github.actions.icon"="archive"
LABEL "com.github.actions.color"="green"

LABEL "repository"="https://github.com/NASA-PDS/gh-action-pds4-ldd.git"
LABEL "homepage"="https://pds-data-dictionaries.github.io/"
LABEL "maintainer"="Jordan Padams <jordan.h.padams@jpl.nasa.gov>"


# Image Details
# -------------

COPY entrypoint.sh /

RUN apt-get update && apt-get install -y \
curl wget python3 default-jre-headless

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
