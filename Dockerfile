FROM nginx:stable

RUN apt update && apt install -y ffmpeg

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY . /usr/share/nginx/html

RUN mkdir -p /usr/share/nginx/html/rick && \
    ffmpeg -i /usr/share/nginx/html/friend.mp4 \
      -codec: copy -start_number 0 -hls_time 8 -hls_list_size 0 -f hls \
      /usr/share/nginx/html/rick/playlist.m3u8 && \
    rm /usr/share/nginx/html/friend.mp4
