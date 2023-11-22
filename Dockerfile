FROM postgres:latest

# Update the package lists and install the PL/Python package
RUN apt-get update \
    && apt-get install -y postgresql-plpython3-16 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
