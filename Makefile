DIST=raspbian_lite
ZIP=${DIST}.zip
IMAGE=${DIST}.img
GST=gst-build

URL=https://downloads.raspberrypi.org/raspbian_lite_latest
CWD=$(shell pwd)

# Docker run arguments
# Container must run in privileged mode to allow binding of loopback interfaces
RUN_ARGS=-it --rm --privileged=true -v ${CWD}/images:/usr/rpi/images -v ${CWD}/${GST}:/usr/rpi/${GST} -w /usr/rpi ryankurte/docker-rpi-emu

# Internal container mount directory
MOUNT_DIR=/media/rpi

default: build

# Pull docker image
pull:
	docker pull ryankurte/docker-rpi-emu

# Bootstrap a RPI image into the images directory
bootstrap: images/${IMAGE}

# Fetch the RPI image from the URL above
images/${IMAGE}:
	mkdir -p images
	wget -O images/${ZIP} -c ${URL}
	unzip -d images/ images/${ZIP}
	mv images/`zipinfo -1 images/${ZIP}` images/${IMAGE}

# Launch the docker image without running any of the utility scripts
run: pull bootstrap
	docker run ${RUN_ARGS} /bin/bash 

# Launch the docker image into an emulated session
run-emu: pull bootstrap
	docker run ${RUN_ARGS} /bin/bash -c './run.sh images/${IMAGE}'

# Copy gstreamer build scripts and resources
copy: pull bootstrap
	docker run ${RUN_ARGS} /bin/bash -c 'mkdir -p ${MOUNT_DIR} && \
		./mount.sh images/${IMAGE} ${MOUNT_DIR} && \
		cp -Rpv /usr/rpi/${GST}/ ${MOUNT_DIR}/usr/; \
		./unmount.sh $(MOUNT_DIR)'

# Remove gstreamer build scripts and resources
remove: pull bootstrap
	docker run ${RUN_ARGS} /bin/bash -c 'mkdir -p ${MOUNT_DIR} && \
		./mount.sh images/${IMAGE} ${MOUNT_DIR} && \
		rm -rf ${MOUNT_DIR}/usr/${GST}; \
		./unmount.sh $(MOUNT_DIR)'

# Run the build script inside the qemu environment
build: copy
	docker run ${RUN_ARGS} /bin/bash -c './run.sh images/${IMAGE} /usr/${GST}/build.sh'

# Run the build-timer script inside the qemu environment
build-timer: copy
	docker run ${RUN_ARGS} /bin/bash -c './run.sh images/${IMAGE} /usr/${GST}/build-timer.sh'