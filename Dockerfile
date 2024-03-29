# syntax=docker/dockerfile:1

# This is a docker file that uses the official docker dbms docker image
# This will extend that image by modifying the image
# The SCS requires that the image support development including things like Pro*C
# This also adds quality of life for git

# Use latest version of the free ORACLE dmbs docker image as base

#SEE ORACLE DOCUMENTATION FOR IMAGE AT
#https://container-registry.oracle.com/ords/f?p=113:4:6365118596284:::4:P4_REPOSITORY,AI_REPOSITORY,AI_REPOSITORY_NAME,P4_REPOSITORY_NAME,P4_EULA_ID,P4_BUSINESS_AREA_ID:1863,1863,Oracle%20Database%20Free,Oracle%20Database%20Free,1,0&cs=3WBkwQsk3YyYBl0FrpmU71E4DsH_lNzGil50PzLgTkFN094ilFgGEJzFgfz7VfcOwu6lsDE-oFppk96EnJM_HSA
FROM container-registry.oracle.com/database/free:latest

# LABEL ca.carleton.scs="Oracle Dev DBMS"
# LABEL ca.carleton.scs.cuoracledevdbms.version="1.0.0"
# ENV DEFAULT_ORACLE_DB_USER ="system"
# ENV LD_LIBRARY_PATH=$ORACLE_BASE/instantclient:$ORACLE_BASE/lib:$LD_LIBRARY_PATH
# ARG DEFAULT_LINUX_USERNAME="oracle"
# ARG ORACLE_INSTANT_CLIENT_FILENAME="oracle-instantclient-release-el8"
# ENV ORACLE_DB_DATA_PATH=$ORACLE_BASE/oradata
# LABEL ca.carleton.scs.cuoracledevdbms.description="This is a Oracle Developer DBMS equiped with a developer environment. To beind data for persistance ensure to map to volume $ORACLE_DB_DATA_PATH"
# LABEL ca.carleton.scs.cuoracledevdbms.oracle_data_path=$ORACLE_DB_DATA_PATH

#Install app dependencies


USER root

# COPY scripts/startup $ORACLE_BASE/scripts/startup
# COPY scripts/setup $ORACLE_BASE/scripts/setup

# RUN dnf group install "Development Tools"


#Install Devlopment Tools. This is useful to compile C,C++ programs
# This also installs Bison and flex-devel for alg, drc, and trc programs
#Latest Version of Instant Client. Must target specific version
# RUN dnf install -y $ORACLE_INSTANT_CLIENT_FILENAME

# RUN dnf install git -y

#SSH and Oracle ports
EXPOSE 22/tcp 1521