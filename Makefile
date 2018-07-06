docker-build:
	docker build \
		-t fdns-ms-gateway \
		--rm \
		--build-arg GATEWAY_PORT=8099 \
		--build-arg GATEWAY_SSL_PORT= \
		--build-arg GATEWAY_SSL_CERT= \
		--build-arg GATEWAY_SSL_KEY= \
		.

docker-run: docker-start
docker-start:
	docker-compose up -d
	docker run -d \
		-p 8099:8099 \
		--network=fdns-ms-gateway_default  \
		--name=fdns-ms-gateway_main \
		fdns-ms-gateway

docker-stop:
	docker stop fdns-ms-gateway_main || true
	docker rm fdns-ms-gateway_main || true
	docker-compose down

docker-restart:
	make docker-stop 2>/dev/null || true
	make docker-start

sonarqube:
	mvn clean test sonar:sonar
