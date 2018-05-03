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
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar

RUN wget https://github.com/oracle/graal/releases/download/vm-1.0.0-rc1/graalvm-ce-1.0.0-rc1-linux-amd64.tar.gz
RUN tar zxvf graalvm-ce-1.0.0-rc1-linux-amd64.tar.gz
# Leave some time for tar and coker to catch up, do something else...
RUN apt-get update && \
    apt-get -y install \
            gcc \
            zlib1g-dev
# ..before returning to grall processing
RUN mv graalvm-1.0.0-rc1 /opt/graal && \
    rm graalvm-ce-1.0.0-rc1-linux-amd64.tar.gz

ENV PATH=$PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN lein jlink init
RUN lein jlink assemble

RUN /opt/graal/bin/native-image -H:+ReportUnsupportedElementsAtRuntime -cp target/jlink/hey.jar hey.core 

#NOTE: If you run jlink on ubuntu, you can't use the same jre on alpine, they have incompatible libc libraries!

FROM debian:sid-slim

RUN mkdir -p /opt/hey
COPY --from=build /usr/src/app/hey.core /opt/hey

ENTRYPOINT /opt/hey/hey.core
