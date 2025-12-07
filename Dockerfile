FROM jrottenberg/ffmpeg:8-scratch AS builder

WORKDIR /data
COPY friend.mp4 .

RUN mkdir rick && \
    ffmpeg -i friend.mp4 \
      -codec copy -start_number 0 -hls_time 8 -hls_list_size 0 -f hls \
      rick/playlist.m3u8

FROM nginx:stable-alpine AS final
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /data/rick /usr/share/nginx/html/rick
COPY index.html tailwind.js sw.js hls.js /usr/share/nginx/html/