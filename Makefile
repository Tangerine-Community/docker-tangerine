build:
	docker build -t ictatrti/tangerine .

run-container:
	docker run -p 49160:80 -d ictatrti/tangerine

test:
	curl localhost:49160

