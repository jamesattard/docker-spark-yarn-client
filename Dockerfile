# Dockerfile for Spark Driver

FROM jamez/alpine-java:8.131.11
LABEL maintainer=" James J. Attard <info@jamesattard.com>"

ENV SPARK_RELEASE spark-2.1.1-bin-hadoop2.7
ENV SPARK_HOME /spark/${SPARK_RELEASE}
ENV PATH ${PATH}:${SPARK_HOME}/bin
ENV HADOOP_CONF_DIR ${SPARK_HOME}/hadoop-conf

RUN set -x \
    && apk add --no-cache --update bash sed grep procps coreutils \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
    && cd /tmp \
    && curl -jksSLO https://d3kbcqa49mib13.cloudfront.net/${SPARK_RELEASE}.tgz \
    && mkdir /spark \
    && tar zxvf ${SPARK_RELEASE}.tgz -C /spark \
    && rm -rf /var/cache/apk/* /tmp/* \
    && cd ${SPARK_HOME}/conf \
    && cp spark-defaults.conf.template spark-defaults.conf \
    && printf "\n\nspark.driver.port    9099\n" >> spark-defaults.conf

WORKDIR ${SPARK_HOME}
EXPOSE 4040 9099
CMD ["/bin/bash"]