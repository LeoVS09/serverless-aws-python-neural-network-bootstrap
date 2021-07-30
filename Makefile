 
#!/usr/bin/env make

.PHONY: setup read-local-enviroment docker-console console install

# ---------------------------------------------------------------------------------------------------------------------
# SETUP
# ---------------------------------------------------------------------------------------------------------------------

setup:
	./setup-env.sh

read-local-enviroment:
	. ./dev.env && echo "$$SECRET_FUNCTION_TOKEN"

install: 
	pipenv install --system

# ---------------------------------------------------------------------------------------------------------------------
# DOCKER
# ---------------------------------------------------------------------------------------------------------------------

docker-console:
	docker-compose run --service-ports serverless-dev-enviroment bash

console: docker-console


chmod:
	chmod -R 777 .

# ---------------------------------------------------------------------------------------------------------------------
# SERVERLESS
# ---------------------------------------------------------------------------------------------------------------------

# Macros to get arguments passed to make command
args = $(filter-out $@,$(MAKECMDGOALS))

# Redeploy entire stack throught cloud function
# Example: make deploy
# Example with stage: make deploy --stage prod
deploy: 
	serverless deploy $(call args)

login: 
	serverless login

# Redeploy only the code + dependencies to update the AWS lambda function
# Faster then full deploy
# example: deploy-fn hello
deploy-fn:
	sls deploy function -f $(call args)

# View logs of hello function and tail via -t flag
# example: make logs hello
logs:
	serverless logs -t -f $(call args)

# Will create function with name `functionName` in `./api/index.js` file and 
# a Javascript function `module.exports.handler` as the entrypoint for the Lambda function
# and add test for them to `test/functionName.js` file
create-function-example: 
	sls create function -f functionName  --handler api/index.handler

create:
	sls create test -f ${FN} --handler ${HANDL}

# ----------------------------------------------------- INVOKE ---------------------------------------------------------

# Invoke the Lambda directly and print log statements via
# Example: make invoke hello
invoke:
	serverless invoke --log --function=$(call args) 

# Invoke functioon localy
# Example: make local hello
local:
	serverless invoke local --log --function=$(call args)

# Unforrtunately we cannot push all enviroment variables to function only by key=value pairs after '-e' paramet
# Example: make local-env hello
local-env:
	. ./dev.env && serverless invoke local --log -e SECRET_FUNCTION_TOKEN="$$SECRET_FUNCTION_TOKEN" --function=$(call args)

# --------------------------------------------------- ENCRIPTION ---------------------------------------------------------

# run command like that `make encript-dev 123`

# Encript dev stage secret file with given password
encript-dev:
	serverless encrypt --stage dev --password $(call args)

# Decript prod stage secrets file with given password
decript-dev:
	serverless decrypt --stage dev --password $(call args)

# Encript prod stage secret file with given password
encript-prod:
	serverless encrypt --stage prod --password $(call args)

# Decript prod stage secrets file with given password
decript-prod:
	serverless decrypt --stage prod --password $(call args)

# --------------------------------------------------- TESTS --------------------------------------------------------------- 

test: 
	pytest
