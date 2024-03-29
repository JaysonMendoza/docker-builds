# syntax=docker/dockerfile:1

# This is a docker file that uses the official docker dbms docker image
# This will extend that image by modifying the image
# The SCS requires that the image support development including things like Pro*C
# This also adds quality of life for git

# Use latest version of the free ORACLE dmbs docker image as base

## SEE OFFICIAL BASE IMAGE DOCUMETNATION AT: https://container-registry.oracle.com/ords/ocr/ba/database/free
FROM container-registry.oracle.com/database/free:latest

LABEL ca.carleton.scs="Oracle Dev DBMS"
LABEL ca.carleton.scs.cuoracledevdbms.imageTag="drazev/cuoracledevdbms"
LABEL ca.carleton.scs.cuoracledevdbms.version="1.0.2"
ENV DEFAULT_ORACLE_DB_USER ="system"
ENV ORACLE_PWD='oracle'
ENV LD_LIBRARY_PATH=$ORACLE_BASE/instantclient:$ORACLE_BASE/lib:$LD_LIBRARY_PATH
ARG DEFAULT_LINUX_USERNAME="oracle"
ARG ORACLE_INSTANT_CLIENT_FILENAME="oracle-instantclient-release-el8"
ENV ORACLE_DB_DATA_PATH=$ORACLE_BASE/oradata
LABEL ca.carleton.scs.cuoracledevdbms.description="This is a Oracle Developer DBMS equiped with a developer environment. To beind data for persistance ensure to map to volume $ORACLE_DB_DATA_PATH"
LABEL ca.carleton.scs.cuoracledevdbms.oracle_data_path=$ORACLE_DB_DATA_PATH

### SETUP VOLUMES FOR PLACES WE WANT TO PERSIST DATA ##

# Database Files
VOLUME $ORACLE_DB_DATA_PATH


### INSTALL PROGRAMS AND MOVE SCRIPTS ###
USER root

COPY scripts/startup $ORACLE_BASE/scripts/startup
COPY scripts/setup $ORACLE_BASE/scripts/setup


# Setup SSHD for ssh
RUN dnf install openssh openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A


#Install Devlopment Tools. This is useful to compile C,C++ programs
# This also installs Bison and flex-devel for alg, drc, and trc programs
#Latest Version of Instant Client. Must target specific version
RUN dnf group install -y "Development Tools"
RUN dnf install -y $ORACLE_INSTANT_CLIENT_FILENAME
RUN dnf install -y git

#SETUP STARTUP SCRIPT, USES STICKBIT so that file can be run as root by oracle user, but oracle user cannot edit file
COPY --chown=root:root --chmod=755 scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+s /usr/local/bin/entrypoint.sh


### FINAL CONTAINER SETUP and DEFAULT USER ###
USER oracle
WORKDIR /home/oracle
RUN echo "[ -f \"README.TXT\" ] && cat README.TXT" >> .bashrc

#SSH and Oracle ports
EXPOSE 22/tcp 1521
ENTRYPOINT /usr/local/bin/entrypoint.sh