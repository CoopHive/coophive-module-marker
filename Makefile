include .env

dc:
	sudo docker-compose up

gh:
	alias docker='sudo docker $@'
	git pull && make dc


docker:
	docker buildx build -t marker:${tag} --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN} .

docker-p:
	docker buildx build --platform linux/amd64 -t marker:${tag} --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN} .


dockerv1:
		docker buildx build -f Dockerfile.v1 -t marker:${tag} --build-arg HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN} .

tag:
	docker tag marker:${tag} laciferin/marker:${tag}
	docker push laciferin/marker:${tag}


.PHONY: docker gh dc tag