FROM maven:3.9-eclipse-temurin-17 AS deps
WORKDIR /deps
COPY docker/webpush-pom.xml pom.xml
RUN mvn -q dependency:copy-dependencies -DoutputDirectory=/deps/lib

FROM tomcat:9.0-jdk17-temurin AS build

WORKDIR /build

COPY --from=deps /deps/lib /build/lib
COPY WEB-INF/lib/*.jar /build/lib/
COPY WEB-INF/classes/DiaryUpdateServlet.java /build/src/
COPY WEB-INF/classes/com/diary/db/DbConfig.java /build/src/com/diary/db/

RUN mkdir -p /build/classes/com/diary/db \
    && javac -cp "/build/lib/*:/usr/local/tomcat/lib/servlet-api.jar" \
         -d /build/classes \
         /build/src/com/diary/db/DbConfig.java \
         /build/src/DiaryUpdateServlet.java

FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

WORKDIR /usr/local/tomcat/webapps/diary-app-java

COPY --from=build /build/classes/ WEB-INF/classes/
COPY --from=build /build/lib/ WEB-INF/lib/
COPY auth/ auth/
COPY css/ css/
COPY diary/ diary/
COPY includes/ includes/
COPY images/ images/
COPY myDiary/ myDiary/
COPY myPage/ myPage/
COPY push/ push/
COPY 404.jsp dbtest.jsp index.jsp sw.js ./

ENV DB_HOST=db \
    DB_PORT=3306 \
    DB_NAME=diary_app_php \
    DB_USER=root \
    DB_PASSWORD=root \
    JAVA_OPTS="-Djava.net.preferIPv4Stack=true"

EXPOSE 8080

CMD ["catalina.sh", "run"]
