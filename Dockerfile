FROM tomcat:9.0
MAINTAINER pandian
COPY **/*.war /usr/local/tomcat/webapps/
