UID_GID = "$(shell id -u):$(shell id -g)"
APP_DIR = $(file < ./secure/var/project_dir)

gen:
	docker run --rm -it \
		-v $(CURDIR):/ansible \
		-v ./secure:/ansible/secure \
		willhallonline/ansible:latest ansible-playbook ansible/gen.yml \
		-i ansible/gen \
		-vv

init:
	if [ ! -d $(APP_DIR) ]; then \
		mkdir $(APP_DIR); fi

run: init
	docker run -it --rm \
		-e HOME=$(HOME) \
		-v $(HOME):$(HOME) \
		-v /etc/passwd:/etc/passwd \
		--user=$(UID_GID) \
		-e USER=$(USER) \
		--entrypoint "" \
		--env-file ./config/.env\
		-v ./config:/config \
		-v $(APP_DIR):/app \
		paulgauthier/aider-full:v0.85.2 aider --config /config/.aider.conf.yml
