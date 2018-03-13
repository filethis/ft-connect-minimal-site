#
# Copyright 2017 FileThis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SHELL := /bin/bash

# Project configuration
NAME=ft-connect-minimal-site
VERSION=0.0.28
LOCAL_PORT=3505
CDN_DISTRIBUTION_ID=EJ2RMYD38WUXM


#------------------------------------------------------------------------------
# Install development tools
#------------------------------------------------------------------------------

.PHONY: install-node-mac
install-node-mac:  ## Install Node (and NPM)
	@brew install node

.PHONY: install-bower
install-bower:  ## Install Bower
	@npm install -g bower

.PHONY: install-polymer-cli
install-polymer-cli:  ## Install Polymer CLI
	npm install -g polymer-cli

.PHONY: install-browser-sync
install-browser-sync:  ## Install BrowserSync
	npm install -g browser-sync;

.PHONY: install
install: install-node-mac install-bower install-polymer-cli install-browser-sync ## Install all development tools
	@echo Installed all development tools


#------------------------------------------------------------------------------
# Serve
#------------------------------------------------------------------------------

.PHONY: serve-browsersync
serve-browsersync:  ## Serve the site using BrowserSync
	@browser-sync start --server --port ${LOCAL_PORT} --files="*.html";

.PHONY: serve-python
serve-python:  ## Serve the site using Python 2.7
	@python -m SimpleHTTPServer ${LOCAL_PORT};

.PHONY: serve-ruby
serve-ruby:  ## Serve the site using Ruby
	@ruby -run -ehttpd . -p${LOCAL_PORT};

.PHONY: serve-node
serve-node:  ## Serve the site using Node "static-server" tool
	@static-server --port ${LOCAL_PORT};

.PHONY: serve-php
serve-php:  ## Serve the site using Node "static-server" tool
	@php -S 127.0.0.1:${LOCAL_PORT};

.PHONY: serve
serve: serve-browsersync  ## Shortcut for "serve-browsersync"
	@echo Serving with BrowserSync...;


#------------------------------------------------------------------------------
# Open in browser
#------------------------------------------------------------------------------

.PHONY: browse
browse:  ## Open the site in browser
	@open http://localhost:${LOCAL_PORT};


#------------------------------------------------------------------------------
# Publish
#------------------------------------------------------------------------------

.PHONY: publish
publish: publish-versioned publish-latest # Internal: Publish both versioned and latest app
	@echo Published both versioned and latest app;

.PHONY: publish-versioned
publish-versioned:  # Internal: Publish versioned app
	@aws s3 sync . s3://connect.filethis.com/${NAME}/${VERSION}/app/ --exclude "*" --include "index.html"; \
	echo https://connect.filethis.com/${NAME}/${VERSION}/app/index.html;

.PHONY: publish-latest
publish-latest:  # Internal: Publish latest app
	@aws s3 sync . s3://connect.filethis.com/${NAME}/latest/app/ --exclude "*" --include "index.html"; \
	echo https://connect.filethis.com/${NAME}/latest/app/index.html;

.PHONY: invalidate-latest
invalidate-latest:  # Internal: Invalidate CDN distribution of latest app
	@if [ -z "${CDN_DISTRIBUTION_ID}" ]; then echo "Cannot invalidate distribution. Define CDN_DISTRIBUTION_ID"; else aws cloudfront create-invalidation --distribution-id ${CDN_DISTRIBUTION_ID} --paths "/${NAME}/latest/app/*"; fi

.PHONY: invalidate
invalidate: invalidate-latest  # Shortcut for "invalidate-latest"
	@echo Invalidated;


#------------------------------------------------------------------------------
# Publications
#------------------------------------------------------------------------------

# Browse published application

.PHONY: publication-browse-app-versioned
publication-browse-app-versioned:  ## Open the published, versioned application in browser
	@open https://connect.filethis.com/${NAME}/${VERSION}/app/index.html;

.PHONY: publication-browse-app-latest
publication-browse-app-latest:  ## Open the published, latest application in browser
	@open https://connect.filethis.com/${NAME}/latest/app/index.html;


# Print URL of published application

.PHONY: publication-url-app-versioned
publication-url-app-versioned:  ## Print the published, versioned application url
	@echo https://connect.filethis.com/${NAME}/${VERSION}/app/index.html;

.PHONY: publication-url-app-latest
publication-url-app-latest:  ## Print the published, latest application url
	@echo https://connect.filethis.com/${NAME}/latest/app/index.html;


#------------------------------------------------------------------------------
# Bower
#------------------------------------------------------------------------------

.PHONY: bower-install-packages
bower-install-packages:  ## Install all Bower packages specified in bower.json file, using symlinks for FileThis projects.
	@mkdir -p ./bower_components; \
	bower install;

.PHONY: bower-clean-packages
bower-clean-packages:  ## Clean all installed bower packages.
	@cd ./bower_components; \
	find . -mindepth 1 -maxdepth 1 -exec rm -rf {} +;

.PHONY: bower-reinstall-packages
bower-reinstall-packages: bower-clean-packages bower-install-packages  ## Clean and reinstall all bower packages using symlinks for FileThis projects.


#------------------------------------------------------------------------------
# Help
#------------------------------------------------------------------------------

.PHONY: help
help:  ## Print Makefile usage. See: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help