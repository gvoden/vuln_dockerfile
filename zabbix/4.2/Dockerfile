FROM debian:bullseye as debian_base

ENV DEBIAN_FRONTEND noninteractive

RUN set -xe \
    && sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list \
    && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update --fix-missing

FROM debian_base
LABEL maintainer="github.com/xxcdd" \
    name="zabbix:4.2" \
    description="zabbix:4.2 web Admin/password" \
    docker.run.cmd="docker run -d -p 80:80 zabbix:4.2"
ADD --chown=www-data:www-data zabbix.conf.php /etc/zabbix/web/zabbix.conf.php
ADD run.sh /
RUN apt-get install -y wget; \
     wget https://repo.zabbix.com/zabbix/4.2/debian/pool/main/z/zabbix-release/zabbix-release_4.2-1%2Bjessie_all.deb; \
     dpkg -i zabbix-release_4.2-1+jessie_all.deb; \
    sed -i 's/repo.zabbix.com/mirrors.aliyun.com\/zabbix/g' /etc/apt/sources.list.d/zabbix.list;\
    apt update; \
    apt install zabbix-server-mysql zabbix-frontend-php zabbix-agent -y;\
    /etc/init.d/mysql start; \
    mysql --user=root --password="" -Bse "create database zabbix character set utf8 collate utf8_bin;"; \
    mysql --user=root --password="" -Bse "create user zabbix@localhost identified by 'password';"; \
    mysql --user=root --password="" -Bse "grant all privileges on zabbix.* to zabbix@localhost;"; \
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -ppassword zabbix; \
    sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_server.conf;\
    sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Riga/g' /etc/zabbix/apache.conf;\
    chmod +x run.sh; ls -ln /etc/zabbix/web/zabbix.conf.php /usr/share/zabbix/conf/zabbix.conf.php
CMD ["sh", "run.sh"]
EXPOSE 80