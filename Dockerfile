FROM python:3.10.0b4 as base

RUN apt update && apt upgrade -y && \
   apt install -y bash bash-completion make curl wget

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs

RUN npm i -g serverless

WORKDIR /app 

COPY package.json package-lock.json /app/
RUN npm i

FROM base

COPY . /app

CMD ["bash"]

