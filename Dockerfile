FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy
RUN apt-get install -qy libssl-dev npm python3.8 python3-pip

RUN useradd  -m -d /app app
WORKDIR /app

COPY requirements.txt /app/
RUN pip3 install -r requirements.txt

COPY package.json /app/
RUN npm install 

COPY . /app/

RUN mkdir /app/build /app/reports && chown app:app /app/build /app/reports

USER app

#RUN python3 -c 'from brownie.project.compiler import install_solc; install_solc("0.8.4")'
#RUN brownie compile
