FROM nginx:1.11.10-alpine
COPY service.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD /bin/sh -c "nginx -g 'daemon off;'"
