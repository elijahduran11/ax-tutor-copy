# This image is still very much a work in progress. It was tested on Linux and allows
# to run tutor from inside docker. In practice, all "tutor" commands should be replaced by:
#
#     docker run --rm -it -P \
#        -v /var/run/docker.sock:/var/run/docker.sock \
#         -v /opt/tutor:/opt/tutor tutor
#
# Note that this image does not come with any plugin, by default. Also, the image does
# not include the `kubectl` binary, so `k8s` commands will not work.
# Because this image is still experimental, and we are not quite sure if it's going to 
# be very useful, we do not provide any usage documentation.

# Update this line
# Base image
FROM python:3.8-slim

# Install Docker CLI and Docker Compose
COPY --from=library/docker:19.03 /usr/local/bin/docker /usr/bin/docker
COPY --from=docker/compose:1.24.0 /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Tutor and required plugins
RUN pip install tutor \
    && tutor plugins update \
    && tutor plugins install indigo mfe \
    && tutor plugins enable indigo mfe

# Set up environment
RUN mkdir /opt/tutor
ENV TUTOR_ROOT=/opt/tutor

# Expose necessary ports
EXPOSE 80 443

# Set entrypoint and default command
ENTRYPOINT ["tutor"]
CMD ["local", "quickstart"]

