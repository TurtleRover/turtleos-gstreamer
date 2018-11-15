DIST=raspbian_lite
ZIP=$(DIST).zip
IMAGE=$(DIST).img

URL=https://downloads.raspberrypi.org/raspbian_lite_latest
CWD=$(shell pwd)

# Docker run arguments
# Container must run in privileged mode to allow binding of loopback interfaces
RUN_ARGS=-it --rm --privileged=true -v $(CWD)/images:/usr/rpi/images -v $(CWD)/resources:/usr/rpi/resources -w /usr/rpi ryankurte/docker-rpi-emu

# Internal container mount directory
MOUNT_DIR=/media/rpi

# Build the docker image
pull:
	@docker pull ryankurte/docker-rpi-emu

# Bootstrap a RPI image into the images directory
bootstrap: images/$(IMAGE)

# Fetch the RPI image from the path above
images/$(IMAGE):
	@mkdir -p images
	@wget -N -O images/$(ZIP) -c $(URL)
	@unzip -d images/ images/$(ZIP)
	@mv $(zipinfo -1 images/${ZIP}) images/$(IMAGE) 

# Launch the docker image without running any of the utility scripts
run: pull bootstrap
	@docker run $(RUN_ARGS) /bin/bash 

# Launch the docker image into an emulated session
run-emu: pull bootstrap
	@docker run $(RUN_ARGS) /bin/bash -c './run.sh images/$(IMAGE)'

# Build some fake resources to copy / execute
# resources: resources/setup.sh
# resources/setup.sh:
# 	@mkdir -p resources
# 	@echo "#!/bin/bash" > resources/setup.sh
# 	@echo "echo Executing example setup script" >> resources/setup.sh
# 	@echo "uname -a" >> resources/setup.sh
# 	@chmod +x resources/setup.sh

# Copy files from local resources directory into image /usr/resources
# Note that the resources directory is mapped to the container as a volume in the RUN_ARGS variable above
# copy: pull bootstrap resources
# 	@echo Copying files
# 	@docker run $(RUN_ARGS) /bin/bash -c 'mkdir $(MOUNT_DIR) && \
# 										./mount.sh images/$(IMAGE) $(MOUNT_DIR) && \
# 										cp -Rv /usr/rpi/resources $(MOUNT_DIR)/usr/; \
# 										./unmount.sh $(MOUNT_DIR)'

# Run a command inside the qemu environment
# setup: copy
# 	@docker run $(RUN_ARGS) /bin/bash -c './run.sh images/$(IMAGE) /usr/resources/setup.sh'

