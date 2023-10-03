IMAGE_NAME_POSTGRES=postgres:14.1-alpine
VOLUME_NAME_POSTGRES=postgresql

IMAGE_NAME_ORACLE=gvenz/oracle-xe:21-slim-faststart
VOLUME_NAME_ORACLE=postgresql

DB_TARGET_IMAGE=$(IMAGE_NAME_POSTGRES)
DB_TARGET_VOLUME=$(VOLUME_NAME_POSTGRES)


pg:
	DB_TARGET_IMAGE=$(IMAGE_NAME_POSTGRES)
	DB_TARGET_VOLUME=$(VOLUME_NAME_POSTGRES)
	sudo docker-compose up --build -d

xe:
	DB_TARGET_IMAGE=$(IMAGE_NAME_ORACLE)
	DB_TARGET_VOLUME=$(VOLUME_NAME_ORACLE)
	sudo docker-compose up --build -d

go:
	./pgconnect.sh

wipe:
	@docker rm -vf $$(docker ps -a --format "table {{.ID}}\t{{.Names}}" | grep "dbp_postgres_db" | cut -f1)
	@docker images | awk '$$1 ~ /dbp_postgres_db/ {print $$3}' | xargs -I {} docker rmi -f {}
