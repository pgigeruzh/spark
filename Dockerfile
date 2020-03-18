FROM ubuntu:18.04

# Install Requirements
RUN apt-get update \
 && apt-get install -y vim curl unzip \
 && apt-get install -y python3 python3-setuptools \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && apt-get install -y python3-pip \
 && apt-get install -y openjdk-8-jre

# Install Spark
ENV SPARK_VERSION 2.4.5
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop2.7
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

# Install JupyterLab
RUN pip3 install jupyterlab
RUN pip3 install pyspark

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]