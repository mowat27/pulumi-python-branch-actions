# See https://tech.davis-hansson.com/p/make/ for a write-up of these settings

# Use bash and set strict execution mode
SHELL:=bash
.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DOCKER_BUILD_SENTINAL := .last-build.sentinal

.PHONY: clean

build: $(DOCKER_BUILD_SENTINAL)
$(DOCKER_BUILD_SENTINAL): Dockerfile *.sh
	@docker build -t mowat27/pulumi-python-branch-actions:dev .
	@touch $(DOCKER_BUILD_SENTINAL)

run: build
	@docker run --rm -t \
		-e PULUMI_ACCESS_TOKEN \
		-v "$(PWD):/code" \
		mowat27/pulumi-python-branch-actions:dev

clean: 
	rm -f $(DOCKER_BUILD_SENTINAL)




