FROM ubuntu:latest as build
RUN apt update
RUN apt install git -y
RUN apt install zip -y
RUN git clone -b main https://github.com/prabhusivakumar/cicd-pipeline.git
RUN cd cicd-pipeline && zip -r webapp.war *

FROM tomcat:8.0-alpine
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /cicd-pipeline/webapp.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh","run"]
