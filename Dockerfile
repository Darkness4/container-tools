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

# --------------------
FROM scratch
# --------------------

COPY --from=build /newroot /
