FROM codeberg.org/forgejo/forgejo:9-rootless

USER root

# تثبيت curl للـ health checks
RUN apk add --no-cache curl

# إنشاء المجلدات المطلوبة
RUN mkdir -p /data/gitea/conf /data/git /data/lfs /data/log && \
    chown -R 1000:1000 /data

USER 1000:1000

EXPOSE 3000

# لا نستخدم CMD الافتراضي، نترك render.yaml يتحكم
