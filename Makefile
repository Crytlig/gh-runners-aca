


.PHONY: image_build
image_build:
	docker buildx build --platform linux/amd64 -t ghrunnerdevweacr.azurecr.io/ghrunner:0.0.1 --build-arg RUNNER_VERSION=2.308.0 --push .
