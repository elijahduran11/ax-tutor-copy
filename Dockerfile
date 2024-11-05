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
# Use a slim Python image as the base
FROM docker.io/python:3.8-slim

# Copy Docker and Docker Compose binaries
COPY --from=library/docker:19.03 /usr/local/bin/docker /usr/bin/docker
COPY --from=docker/compose:1.24.0 /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Tutor
RUN pip install tutor

# Create the Tutor root directory and set environment variable
RUN mkdir /opt/tutor
ENV TUTOR_ROOT=/opt/tutor

# Run tutor as a non-root user
RUN useradd -m tutoruser
USER tutoruser
WORKDIR /home/tutoruser

# Update plugin index and install plugins
RUN tutor plugins update && \
    tutor plugins install indigo && tutor plugins enable indigo && \
    tutor plugins install mfe && tutor plugins enable mfe

# Expose HTTP and HTTPS ports
EXPOSE 80
EXPOSE 443

# Set the entry point to Tutor
ENTRYPOINT ["tutor"]

# Default command to start the container
CMD ["local", "quickstart"]

CMD ["local", "quickstart"]

