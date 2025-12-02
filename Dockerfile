FROM node:20 AS base
RUN curl -sSL https://encore.dev/install.sh | bash
ENV PATH="/root/.encore/bin:${PATH}"

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 4000

CMD ["encore", "run", "--watch=false", "--port=4000", "--listen=0.0.0.0:4000"]
