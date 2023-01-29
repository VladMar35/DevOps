#Dockerfile
FROM node:16
RUN apt update && \
    apt install -y unzip curl \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf \
        awscliv2.zip \
    && apt -y purge curl \
    && apt -y purge unzip

COPY project_frontend/ts-redux-react-realworld-example-app /app

WORKDIR /app
RUN npm clean-install
RUN npm run build
