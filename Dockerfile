FROM golang:1.10
WORKDIR /go/src/script-exporter
COPY . .
RUN CGO_ENABLED=0 GOOS=linux make

FROM debian
RUN apt-get update && apt-get install -y openssl dnsutils
WORKDIR /tmp/
COPY --from=0 /go/src/script-exporter/script-exporter script-exporter.sh
RUN chmod +x script-exporter.sh

CMD /tmp/script-exporter.sh -script.path /tmp/scripts -web.listen-address :9661
