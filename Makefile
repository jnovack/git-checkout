
run:
	docker run -it --rm git-checkout /bin/sh

build:
	docker build -t git-checkout .
