deploy:
	source venv/bin/activate; \
	$(aws ecr get-login --no-include-email --region us-east-1) \
	docker build -t log3900-server .; \
	docker tag log3900-server:latest 042607413139.dkr.ecr.us-east-1.amazonaws.com/log3900-server:latest; \
	docker push 042607413139.dkr.ecr.us-east-1.amazonaws.com/log3900-server:latest; \