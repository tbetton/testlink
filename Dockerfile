FROM debian:latest

MAINTAINER tbetton777

RUN apt-get update -yqq && \
    apt-get install -yqq apache2 php7.3 wget php7.3-mysql php7.3-curl

RUN wget -q -O - https://github.com/TestLinkOpenSourceTRMS/testlink-code/archive/1.9.19.tar.gz | tar zxvf - && \
    mv testlink-code-1.9.19 /var/www/html/testlink #&& \
    # rm testlink-code-1.9.19.tar.gz

RUN echo "max_execution_time=3000" >> /etc/php5/apache2/php.ini && \
    echo "session.gc_maxlifetime=60000" >> /etc/php5/apache2/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

RUN mkdir -p /var/testlink/logs /var/testlink/upload_area

RUN chmod 777 -R /var/www/html/testlink && \
    chmod 777 -R /var/testlink/logs && \
    chmod 777 -R /var/testlink/upload_area

VOLUME /var/testlink

EXPOSE 80/tcp

CMD ["/usr/sbin/apache2","-D", "FOREGROUND"]
