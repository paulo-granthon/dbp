CONTAINER_NAME=dbp_container_db

pg:
	. ./.env
	DB_TARGET_IMAGE=postgres:14.1-alpine \
	DB_TARGET_VOLUME=postgresql \
	docker-compose up --build -d

xe:
	. ./.env
	DB_TARGET_IMAGE=gvenz/oracle-xe:21-slim-faststart \
	DB_TARGET_VOLUME=oraclexe \
	docker-compose up --build -d

go:
	./pgconnect.sh

wipe:
	@docker rm -vf $$(docker ps -a --format "table {{.ID}}\t{{.Names}}" | grep "${CONTAINER_NAME}" | cut -f1)
	@docker images | awk '$$1 ~ /${CONTAINER_NAME}/ {print $$3}' | xargs -I {} docker rmi -f {}
