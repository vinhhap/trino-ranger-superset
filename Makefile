build-ranger-admin:
	cd docker-images/ranger && \
	docker build --build-arg RANGER_VERSION=$(RANGER_ADMIN_VERSION) -f Dockerfile -t $(RANGER_ADMIN_IMAGE):$(RANGER_ADMIN_VERSION) .

build-trino:
	cd docker-images/trino && \
	docker build --build-arg TRINO_VERSION=$(TRINO_VERSION) --build-arg TRINO_PLUGIN_VERSION=$(TRINO_PLUGIN_VERSION) -f Dockerfile -t $(TRINO_IMAGE):$(TRINO_VERSION) .

build-superset:
	cd docker-images/superset && \
	docker build --build-arg SUPERSET_VERSION=$(SUPERSET_VERSION) -f Dockerfile -t $(SUPERSET_IMAGE):$(SUPERSET_VERSION) .