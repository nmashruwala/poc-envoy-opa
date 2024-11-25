# Basic Dockerfile for Envoy
FROM harbor.wsbidev.net/stage-needham/wasabi/envoy-contrib:7.23.3307-2024-10-25-31a72718fc

# Set the default command to run Envoy with the configuration file
CMD ["envoy", "-c", "/etc/envoy/envoy.yaml"]
