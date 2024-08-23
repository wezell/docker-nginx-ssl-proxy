FROM nginx:1.27.1

ENV S6_OVERLAY_SHA256_amd64 65f6e4dae229f667e38177d5cad0159af31754b9b8f369096b5b7a9b4580d098
ENV S6_OVERLAY_SHA256_x_86_64 65f6e4dae229f667e38177d5cad0159af31754b9b8f369096b5b7a9b4580d098
ENV ENVPLATE_SHA256 8366c3c480379dc325dea725aac86212c5f5d1bf55f5a9ef8e92375f42d55a41
ENV CLOUDFLARE_V4_SHA256 db746a8739a51088c27d0b3c48679d21a69aab304d4c92af3ec0e89145b0cadd
ENV CLOUDFLARE_V6_SHA256 559b5c5a20088758b4643621ae80be0a71567742ae1fe8e4ff32d1ca26297f8f

ARG TARGETARCH


COPY build.sh /build.sh
RUN chmod +x /build.sh
RUN /build.sh

COPY services.d/nginx/* /etc/services.d/nginx/
COPY services.d/certbot/* /etc/services.d/certbot/
COPY nginx.conf security_headers.conf hsts.conf /etc/nginx/
COPY proxy.conf /etc/nginx/conf.d/default.conf
COPY auth_part*.conf /root/
COPY dhparams.pem /etc/nginx/
COPY temp-setup-cert.pem /etc/nginx/temp-server-cert.pem
COPY temp-setup-key.pem /etc/nginx/temp-server-key.pem

VOLUME "/etc/letsencrypt"

ENTRYPOINT ["/init"]
CMD []
