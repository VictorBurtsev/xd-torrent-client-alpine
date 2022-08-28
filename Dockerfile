FROM alpine:3.16 as build

RUN apk add go~1 \
        build-base~0 \
        git~2 \
        yarn~1 \
            && git clone https://github.com/majestrate/XD /root/XD \
            && cd /root/XD \
            && sed -i 's/127.0.0.1/172.29.0.1/g' lib/network/i2p/common.go \
            && make

FROM alpine:3.16

WORKDIR "/home/xd/data"

COPY --from=build /root/XD/XD .

RUN addgroup -g 1001 xd \
        && adduser -S -u 1001 -G xd xd \
        && chown -R xd:xd /home/xd/data \
        && chmod +x /home/xd/data/XD \
        && ln -s /home/xd/data/XD /home/xd/data/xd-cli

USER xd

CMD ./XD torrents.ini