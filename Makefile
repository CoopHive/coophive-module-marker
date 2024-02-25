dc:
	sudo docker-compose up

gh:
	alias docker='sudo docker $@'
	git pull && make dc