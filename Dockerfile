FROM nvidia/dcgm:4.4.1-2-ubuntu22.04

WORKDIR /app

COPY dcgm-go-test .

ENTRYPOINT ["/app/dcgm-go-test"]