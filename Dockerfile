FROM codeberg.org/forgejo/forgejo:9-rootless

USER root

RUN apk add --no-cache curl

RUN mkdir -p /data/gitea/conf /data/git /data/lfs /data/log && \
    chown -R 1000:1000 /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER 1000:1000

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
