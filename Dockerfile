# deploy war file to tomcat from mvn_build
FROM tomcat:8.0
COPY  target/*.war /usr/local/tomcat/webapps

