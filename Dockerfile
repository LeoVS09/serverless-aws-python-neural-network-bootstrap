FROM tensorflow/tensorflow:2.5.0-gpu as base

RUN apt update && apt upgrade -y && \
   apt install -y bash bash-completion make curl wget git

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs

RUN npm i -g serverless

WORKDIR /app 

COPY package.json package-lock.json /app/
RUN npm i

FROM base as second

COPY dev.requirements.txt /app/

RUN pip3 install -r dev.requirements.txt

RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable autoscroll/main && \
    jupyter serverextension enable --py jupyter_http_over_ws

FROM second

COPY . /app

CMD [ "make", "notebook" ]

