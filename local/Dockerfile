FROM nginx:1.13.5
COPY gzip.conf /etc/nginx/conf.d/gzip.conf
COPY service.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443
CMD nginx -g 'daemon off;'
