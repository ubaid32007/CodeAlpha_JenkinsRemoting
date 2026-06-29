# ──────────────────────────────────────────────────
# CodeAlpha DevOps Internship — Task 2
# Jenkins Remoting Project — MASTER NODE
# ──────────────────────────────────────────────────

FROM jenkins/jenkins:lts

# Switch to root to install tools
USER root

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Skip Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--httpPort=8080"

# Copy pre-installed plugins list
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Copy Groovy init scripts (auto-configure Jenkins on startup)
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Switch back to jenkins user
USER jenkins

EXPOSE 8080 50000
