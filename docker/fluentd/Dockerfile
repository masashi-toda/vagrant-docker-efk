# https://hub.docker.com/r/fluent/fluentd/
FROM fluent/fluentd:v1.0.2

# Add your fluentd plugins setup here
RUN ["gem", "install", "fluent-plugin-ua-parser", "--no-rdoc", "--no-ri", "--version", "1.2.0"]
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "2.4.1"]
