FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy
RUN apt-get install -qy libssl-dev npm python3.8 python3-pip
RUN npm install -g ganache-cli
RUN pip3 install eth-brownie

RUN useradd  -m -d /work work
WORKDIR /app

COPY . /app/
RUN pip3 install -r requirements.txt
USER work
