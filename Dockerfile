FROM node:14 AS starter 

FROM python:3.9 AS builder

COPY --from=starter /usr/local/bin /usr/local/bin
COPY --from=starter /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

ARG AMP_DOC_TOKEN

ENV APM_DOC_TOKEN=${AMP_DOC_TOKEN}
ENV APP_ENV=production
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
    apt-get install \
        curl \ 
        build-essential \
        git \
        libyaml-dev \ 
        parallel -y 

#RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
#    apt-get install -y nodejs

WORKDIR /app
COPY . .

RUN npm install
RUN npx gulp buildPrepare
RUN npx gulp unpackArtifacts
RUN pip install grow --upgrade-strategy eager

#Build Languages - Uncomment languages that you want to build 
RUN npx gulp buildPages --locales 'en'
#RUN npx gulp buildPages --locales 'de'
#RUN npx gulp buildPages --locales 'fr'
#RUN npx gulp buildPages --locales 'ar'
#RUN npx gulp buildPages --locales 'es'
#RUN npx gulp buildPages --locales 'it'
#RUN npx gulp buildPages --locales 'id'
#RUN npx gulp buildPages --locales 'ja'
#RUN npx gulp buildPages --locales 'ko'
#RUN npx gulp buildPages --locales 'pt_BR'
#RUN npx gulp buildPages --locales 'ru'
#RUN npx gulp buildPages --locales 'zh_CN'
#RUN npx gulp buildPages --locales 'pi'
#RUN npx gulp buildPages --locales 'vi'
#RUN npx gulp buildPages --locales 'en'



RUN npx gulp buildFinalize

FROM httpd:2.4 AS final

COPY --from=builder /app/dist/pages/ /usr/local/apache2/htdocs/
RUN mkdir /usr/local/apache2/htdocs/playground
COPY --from=builder /app/dist/playground/ /usr/local/apache2/htdocs/playground/
