include .env

dc:
	sudo docker-compose up

gh:
	alias docker='sudo docker $@'
	git pull && make dc


docker:
	docker buildx build -t marker --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN} .

docker-p:
	docker buildx build --platform linux/amd64 -t marker:linux-amd64 --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN} .


tag:
	docker tag marker:${tag} laciferin/marker:${tag}
	docker push laciferin/marker:${tag}


.PHONY: docker gh dc tag