build:
	docker build -t adam704a/tangerine .

run-container:
	# hostPort:containerPort
	docker run --name tangerine -p 49161:80 -d adam704a/tangerine

inspect:
	docker run -i -t adam704a/tangerine /bin/bash

test:
	curl $(boot2docker ip):49161

clean:
	docker stop tangerine
	docker rm tangerine

