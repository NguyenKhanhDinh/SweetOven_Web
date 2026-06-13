FROM gradle:8.14-jdk21 AS builder
WORKDIR /app
COPY . .
RUN gradle war --no-daemon

FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder /app/build/libs/TTLTW.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]