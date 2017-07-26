FROM nginx:1.11.10-alpine
COPY gzip.conf /etc/nginx/conf.d/gzip.conf
COPY service.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443
CMD /bin/sh -c "nginx -g 'daemon off;'"
