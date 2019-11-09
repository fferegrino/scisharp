FROM python:3.7-slim

RUN apt-get update && \
    apt-get install wget gnupg2 -y && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/10/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get update && \
    apt-get install apt-transport-https -y && \
    apt-get update && \
    apt-get install dotnet-sdk-3.0 -y

ENV PATH "$PATH:/root/.dotnet/tools/"

RUN pip install jupyterlab

RUN dotnet tool install -g dotnet-try && \
    dotnet try jupyter install && \
    jupyter kernelspec list && \
    mkdir /notebooks

ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--notebook-dir=/notebooks"]