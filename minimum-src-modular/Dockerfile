FROM openjdk:10-jdk as build

ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/

WORKDIR /tmp

# Download the whole repo as an archive
RUN mkdir -p $LEIN_INSTALL \
  && wget -q https://raw.githubusercontent.com/technomancy/leiningen/$LEIN_VERSION/bin/lein-pkg \
  && mv lein-pkg $LEIN_INSTALL/lein \
  && chmod 0755 $LEIN_INSTALL/lein \
  && wget -q https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
  && wget -q https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip.asc \
  && rm leiningen-$LEIN_VERSION-standalone.zip.asc \
  && mkdir -p /usr/share/java \
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar \
  && wget https://github.com/oracle/graal/releases/download/vm-1.0.0-rc1/graalvm-ce-1.0.0-rc1-linux-amd64.tar.gz \\
  && tar zxvf graalvm-ce-1.0.0-rc1-linux-amd64.tar.gz \
  && rm graalvm-ce-1.0.0-rc1-linux-amd64.tar.gz

ENV PATH=$PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

# Install clojure 1.9.0 so users don't have to download it every time
RUN echo '(defproject dummy "" :dependencies [[org.clojure/clojure "1.9.0"]])' > project.clj \
  && lein deps && rm project.clj

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN lein jlink init
RUN lein jlink assemble
RUN lein jlink package

#NOTE: If you run jlink on ubuntu, you can't use the same jre on alpine, they have incompatible libc libraries!

FROM debian:sid-slim

ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/

# Download Leiningen for the final product
RUN yes | apt-get update
RUN yes | apt-get install gcc
RUN yes | apt-get install zlib1g-dev
RUN yes | apt-get install wget

COPY --from=build /usr/src/app/target/jlink /opt/hey
COPY --from=build /usr/src/app/graalvm-1.0.0-rc1 /opt/graal
COPY --from=build /root/.m2 /root/.m2
WORKDIR /opt/hey
ENV PATH=$PATH:/opt/hey/bin
ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/

# Download the whole repo as an archive
RUN mkdir -p $LEIN_INSTALL \
  && wget -q https://raw.githubusercontent.com/technomancy/leiningen/$LEIN_VERSION/bin/lein-pkg \
  && mv lein-pkg $LEIN_INSTALL/lein \
  && chmod 0755 $LEIN_INSTALL/lein \
  && wget -q https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
  && wget -q https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip.asc \
  && rm leiningen-$LEIN_VERSION-standalone.zip.asc \
  && mkdir -p /usr/share/java \
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar
RUN mkdir /opt/hey/test /opt/hey/src /opt/hey/dev-resources /opt/hey/resources /opt/hey/target /opt/hey/target/classes  \
    && echo '(defproject dummy "" :dependencies [[org.clojure/clojure "1.9.0"]])' > project.clj \
    && /opt/graal/bin/native-image -H:+ReportUnsupportedElementsAtRuntime -cp `lein cp`:hey.jar hey.core
RUN rm hey.jar
ENTRYPOINT /opt/hey/hey.core

