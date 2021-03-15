FROM openjdk:8

ENV JMETER_VERSION="5.4"
ENV JMETER_DOWNLOAD_URL  http://apache.stu.edu.tw//jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz

# Add dockerize tool -------------------
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /opt/apache-jmeter-$JMETER_VERSION

RUN wget $JMETER_DOWNLOAD_URL
RUN tar -xzf apache-jmeter-$JMETER_VERSION.tgz
RUN mv apache-jmeter-$JMETER_VERSION/* /opt/apache-jmeter-$JMETER_VERSION
RUN rm -r /opt/apache-jmeter-$JMETER_VERSION/apache-jmeter-$JMETER_VERSION

######## Add plugins
ENV JMETER_PLUGINS_MANAGER_VERSION="1.6"
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/$JMETER_PLUGINS_MANAGER_VERSION/jmeter-plugins-manager-$JMETER_PLUGINS_MANAGER_VERSION.jar
RUN mv jmeter-plugins-manager-$JMETER_PLUGINS_MANAGER_VERSION.jar /opt/apache-jmeter-$JMETER_VERSION/lib/ext

ENV JMETER_CASUTG_PLUGIN_VERSION="2.9"
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-casutg/$JMETER_CASUTG_PLUGIN_VERSION/jmeter-plugins-casutg-$JMETER_CASUTG_PLUGIN_VERSION.jar
RUN mv jmeter-plugins-casutg-$JMETER_CASUTG_PLUGIN_VERSION.jar /opt/apache-jmeter-$JMETER_VERSION/lib/ext
########

ENTRYPOINT ["/opt/apache-jmeter-$JMETER_VERSION/code/entry.sh"]
