dc:
	sudo docker-compose up

gh:
	alias docker='sudo docker $@'
	git pull && make dc


docker:
	docker buildx build -t marker --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN} .

.PHONY: docker gh dc