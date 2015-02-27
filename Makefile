build:
	docker build -t ictatrti/tangerine .

run-container:
	# hostPort:containerPort
	docker run -p 49160:80 --name tangerine -d ictatrti/tangerine

inspect:
	docker run -i -t ictatrti/tangerine /bin/bash

test:
	curl $(boot2docker ip):49160

clean:
	docker stop tangerine
	docker rm tangerine
	docker rm $(docker ps -a -q)

