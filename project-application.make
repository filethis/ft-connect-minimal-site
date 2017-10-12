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


# Targets common to both application and element projects
include project-common.make


# Validation -----------------------------------------------------------------------------------

.PHONY: polymerlint
polymerlint:  ## Run Polymer linter on project files
	@polymer lint --input ./src/${NAME}.html;

.PHONY: eslint
eslint:  ## ESLint project files
	@eslint --ext .html,.js ./src;


# Building -----------------------------------------------------------------------------------

.PHONY: build-app
build-app:  ## Build application
	@polymer build;

.PHONY: clean-app
clean-app:  ## Clean application
	@rm -rf ./build/;


.PHONY: build-dist
build-dist: clean-dist build-app  ## Build distribution
	@mkdir -p ./dist; \
	pushd ./build; \
	zip -r ../dist/es5-bundled.zip ./es5-bundled

.PHONY: clean-dist
clean-dist:  ## Clean distribution
	@rm -rf ./dist/;


.PHONY: clean-app-docs
clean-app-docs:  ## Clean application documentation page
	@rm -f ./docs/index.html;


# Running -----------------------------------------------------------------------------------

.PHONY: open
open:  ## Run BrowserSync
	@browser-sync start \
		--config "bs-config.js" \
		--server \
		--port ${LOCAL_PORT};

.PHONY: open-test
open-test:  ## Run BrowserSync for tests
	@browser-sync start \
		--config "bs-config.js" \
		--server \
		--port ${LOCAL_PORT} \
		--index "/test/${NAME}/${NAME}_test.html";


# Application -----------------------------------------------------------------------------------

.PHONY: open-app
open-app:  ## Open URL of application published on GitHub Pages
	@open https://${GITHUB_USER}.github.io/${NAME}/;

.PHONY: url-app
url-app:  ## Print URL of application published on GitHub Pages
	@echo https://${GITHUB_USER}.github.io/${NAME}/;


# Docs -----------------------------------------------------------------------------------

.PHONY: open-docs
open-docs:  ## Open URL of application documentation published on GitHub Pages
	@open https://${GITHUB_USER}.github.io/${NAME}/;

.PHONY: url-docs
url-docs:  ## Print URL of application documentation published on GitHub Pages
	@echo https://${GITHUB_USER}.github.io/${NAME}/;


# Release -----------------------------------------------------------------------------------

.PHONY: publish-github-pages
publish-github-pages: build-dist
	@bin_dir="$$(dirname `which gh-pages`)"; \
	parent_dir="$$(dirname $$bin_dir)"; \
	lib_dir=$$parent_dir/lib; \
	rm -rf $$lib_dir/node_modules/gh-pages/.cache; \
	gh-pages \
		--repo https://github.com/${GITHUB_USER}/${NAME}.git \
		--branch gh-pages \
		--silent \
		--dist ./build/es5-bundled; \
	echo Published version ${VERSION} of application \"${NAME}\" to GitHub Pages at https://${GITHUB_USER}.github.io/${NAME};

#.PHONY: publish-github-pages
#publish-github-pages: build-dist # Internal target: Publish application docs on GitHub Pages. Usually invoked as part of a release via 'release' target.
#	@bin_dir="$$(dirname `which gh-pages`)"; \
#	parent_dir="$$(dirname $$bin_dir)"; \
#	lib_dir=$$parent_dir/lib; \
#	rm -rf $$lib_dir/node_modules/gh-pages/.cache; \
#	gh-pages \
#		--repo https://github.com/${GITHUB_USER}/${NAME}.git \
#		--branch gh-pages \
#		--dist ./docs/ \
#		--remove ./docs/README.md; \
#	echo Published documentation for version ${VERSION} of application \"${NAME}\" to GitHub Pages at https://${GITHUB_USER}.github.io/${NAME};

.PHONY: bower-register
bower-register:  # Internal target: Register element in public Bower registry. Usually invoked as part of a release via 'release' target.
	@echo TODO: Should Polymer applications be registered in Bower?;



