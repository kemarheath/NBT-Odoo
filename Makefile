IMAGE_NAME=kemarheath/ocb-odoo
TAG=18.0

build:
	docker build -t $(IMAGE_NAME):$(TAG) .

run:
	docker run -d \
		-p 8069:8069 \
		-v odoo-data:/var/lib/odoo \
		-v ./extra-addons:/mnt/extra-addons \
		--name ocb \
		$(IMAGE_NAME):$(TAG)

backup:
	docker exec -t ocb pg_dumpall -c -U odoo > backups/odoo_$(shell date +%F).sql

restore:
	cat backups/odoo_*.sql | docker exec -i ocb psql -U odoo

push:
	docker push $(IMAGE_NAME):$(TAG)

.PHONY: build run backup restore push
