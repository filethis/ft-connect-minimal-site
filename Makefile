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
VERSION=0.0.22
LOCAL_PORT=3505


# Open in browser -----------------------------------------------------------------------------------

.PHONY: open
open:  ## Open the site in browser
	@open http://localhost:${LOCAL_PORT};


# Serve -----------------------------------------------------------------------------------

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


# Release -----------------------------------------------------------------------------------

.PHONY: release-app
release-app:  # Internal: Release distribution
	@aws s3 sync . s3://connect.filethis.com/${NAME}/v${VERSION}/app/ --exclude "*" --include "index.html";


# Help -----------------------------------------------------------------------------------

.PHONY: help
help:  ## Print Makefile usage. See: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help