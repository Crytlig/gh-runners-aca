.PHONY: build_image
build_image:
	docker buildx build -t ghrunnerdevweacr.azurecr.io/ghrunner:0.0.1 --build-arg RUNNER_VERSION=2.308.0 .


.PHONY: run_image
run_image:
	docker run --env-file .env --platform linux/amd64 ghrunnerdevweacr.azurecr.io/ghrunner:0.0.1


.PHONY: push_image
push_image:
	az acr login -n ghrunnerdevweacr && \
  docker push ghrunnerdevweacr.azurecr.io/ghrunner:0.0.1

