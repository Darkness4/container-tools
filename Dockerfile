# --------------------------
FROM alpine AS build
# --------------------------

# Build rootfs from scratch
RUN apk --allow-untrusted \
  -X http://dl-cdn.alpinelinux.org/alpine/edge/main \
  -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
  -U \
  -p /newroot \
  --no-cache \
  --initdb \
  add \
  ca-certificates \
  openssl \
  gnupg \
  sqlite \
  zstd \
  openssh-client \
  'jq<2' \
  curl \
  'gomplate<5' \
  logrotate \
  # For JWT's JTI field.
  uuidgen

RUN mkdir -p /newroot/etc && \
  echo "root:x:0:0:root:/root:/sbin/nologin" >> /newroot/etc/passwd && \
  echo "user1000:x:1000:1000:user1000:/home/user1000:/sbin/nologin" >> /newroot/etc/passwd && \
  echo "user1001:x:1001:1001:user1001:/home/user1001:/sbin/nologin" >> /newroot/etc/passwd && \
  echo "root:x:0:" >> /newroot/etc/group && \
  echo "user1000:x:1000:" >> /newroot/etc/group && \
  echo "user1001:x:1001:" >> /newroot/etc/group && \
  mkdir -p /newroot/home/user1000 /newroot/home/user1001 /newroot/root && \
  chown 0:0 /newroot/root && \
  chown 1000:1000 /newroot/home/user1000 && \
  chown 1001:1001 /newroot/home/user1001 && \
  chmod 750 /newroot/root /newroot/home/user1000 /newroot/home/user1001

# --------------------
FROM scratch
# --------------------

COPY --from=build /newroot /
