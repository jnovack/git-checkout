.PHONY: build run exec push dev all

all: build run

dev: build exec

clean:
	docker rmi jnovack/git-checkout || true

build:
	docker build -t jnovack/git-checkout .

run:
	docker run -it --rm jnovack/git-checkout $(CMD)

exec:
	docker run -it --rm --entrypoint=/bin/sh jnovack/git-checkout

push: build
	docker push jnovack/git-checkout
