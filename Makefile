run:
	docker-compose up --build -d

go:
	./pgconnect.sh

wipe:
	@docker rm -vf $$(docker ps -a --format "table {{.ID}}\t{{.Names}}" | grep "dbp_postgres_db" | cut -f1)
	@docker images | awk '$$1 ~ /dbp_postgres_db/ {print $$3}' | xargs -I {} docker rmi -f {}
