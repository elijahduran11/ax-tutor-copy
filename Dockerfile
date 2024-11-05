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
FROM docker.io/python:3.8-slim

# Create a non-root user
RUN useradd -m tutoruser
USER tutoruser

# Set up the Tutor directory
RUN mkdir /opt/tutor
ENV TUTOR_ROOT=/opt/tutor

# Install Tutor, upgrade pip, and install plugins in a single step
RUN pip install --upgrade pip \
    && pip install tutor \
    && tutor plugins update \
    && tutor plugins install indigo mfe \
    && tutor plugins enable indigo mfe \
    && tutor local launch || true  # Ensure Tutor project root is initialized

# Expose necessary ports
EXPOSE 80
EXPOSE 443

# Set default entrypoint and command for Tutor
ENTRYPOINT ["tutor"]
CMD ["local", "launch"]



