FROM centos:7

LABEL maintainer="zuoguocai@126.com"  version="1.0" description="daohang"



RUN set -ex \
    && yum install -y epel-release wget \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "LANG=en_US.utf8" > /etc/locale.conf \
    && wget  -O  /etc/yum.repos.d/openresty.repo   https://openresty.org/package/centos/openresty.repo \
    && yum install -y openresty \
    && yum remove -y wget \
    && yum clean all \
    && rm -rf /var/tmp/yum*;rm -rf /usr/local/openresty/nginx/conf/nginx.conf


WORKDIR /web
RUN  mkdir /web/ai;mkdir /var/log/nginx
RUN useradd nginx
ADD ai ./ai

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
RUN chown -R nginx:nginx /web
EXPOSE 80
CMD ["openresty", "-g", "daemon off;"]
