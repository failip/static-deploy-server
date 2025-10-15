FROM macbre/nginx-http3:1.29.2

USER root

RUN apk add --no-cache fcgiwrap spawn-fcgi gettext su-exec

COPY upload-handler.sh /usr/local/bin/upload-handler.sh
RUN chmod +x /usr/local/bin/upload-handler.sh

COPY nginx.conf.template /etc/nginx/nginx.conf.template

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN adduser www-writer -D -H -s /sbin/nologin
RUN mkdir -p /var/www/uploads
RUN chown -R www-writer:www-data /var/www/uploads && chmod -R u=rwx,g=rx,o=rx /var/www/uploads

RUN mkdir -p /tmp/uploads
RUN chown -R www-writer:www-data /tmp/uploads && chmod -R u=rwx,g=rx,o=rx /tmp/uploads

CMD ["/usr/local/bin/docker-entrypoint.sh"]
