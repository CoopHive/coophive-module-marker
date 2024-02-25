dc:
	sudo docker-compose up

gh:
	alias docker='sudo docker $@'
	git pull && make dc


docker-build:
	docker build -t marker --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}
