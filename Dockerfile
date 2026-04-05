FROM tomcat:10-jdk17

# Set environment variables
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Create webapp directory with proper permissions
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    chmod -R 755 /usr/local/tomcat/webapps/ROOT && \
    chmod -R 755 /usr/local/tomcat/work && \
    chmod -R 755 /usr/local/tomcat/temp

# Copy entire app to Tomcat webapps
COPY . /usr/local/tomcat/webapps/ROOT/

# Ensure all JSP files have proper permissions
RUN find /usr/local/tomcat/webapps/ROOT -name "*.jsp" -exec chmod 644 {} \; && \
    find /usr/local/tomcat/webapps/ROOT -name "*.html" -exec chmod 644 {} \;

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
