FROM debian:bullseye as debian_base

ENV DEBIAN_FRONTEND noninteractive

RUN set -xe \
    && sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list \
    && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update --fix-missing

FROM debian_base
LABEL maintainer="github.com/xxcdd" \
    name="zabbix:web3.0.3" \
    description="zabbix:web3.0.3 web Admin/password" \
    docker.run.cmd="docker run -d -p 80:80 zabbix:web3.0.3"
ADD run.sh /
RUN apt-get install -y wget; \
     wget https://mirrors.aliyun.com/zabbix/zabbix/3.0/debian/pool/main/z/zabbix-release/zabbix-release_3.0-1%2Bjessie_all.deb;\
    dpkg -i zabbix-release_3.0-1+jessie_all.deb;\
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
    chmod +x run.sh; \
    wget https://cdn.zabbix.com/zabbix/sources/stable/3.0/zabbix-3.0.3.tar.gz;\
    tar -zxvf zabbix-3.0.3.tar.gz zabbix-3.0.3/frontends/php/;\
    rm -rf /usr/share/zabbix/*;cp -r zabbix-3.0.3/frontends/php/* /usr/share/zabbix/;\
    rm -rf zabbix-3.0.3*
ADD zabbix.conf.php /usr/share/zabbix/conf/zabbix.conf.php
CMD ["sh", "run.sh"]
EXPOSE 80