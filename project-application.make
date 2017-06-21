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


# Targets common to both application and element projects
include project-common.make


# Validation -----------------------------------------------------------------------------------

.PHONY: lint
lint:  ## Lint project files
	@polymer lint --root src/ --input ${NAME}.html;


# Building -----------------------------------------------------------------------------------

.PHONY: build-app
build-app:  ## Build application
	@polymer build;

.PHONY: clean-app
clean-app:  ## Clean application
	@rm -rf ./build/;

.PHONY: clean-app-docs
clean-app-docs:  ## Clean application documentation page
	@rm -f ./docs/index.html;


# Running -----------------------------------------------------------------------------------

.PHONY: run-browser-sync
run-browser-sync:  ## Run BrowserSync
	@browser-sync start \
		--config "bs-config.js" \
		--server \
		--port ${LOCAL_PORT};

.PHONY: run-browser-sync-test
run-browser-sync-test:  ## Run BrowserSync for tests
	@browser-sync start \
		--config "bs-config.js" \
		--server \
		--port ${LOCAL_PORT} \
		--index "/test/${NAME}/${NAME}_test.html";


# Application -----------------------------------------------------------------------------------

.PHONY: open-url-local
open-url-local:  ## Open URL of local application
	@open http://localhost:${LOCAL_PORT};

.PHONY: print-url-local
print-url-local:  ## Print URL of local application
	@echo http://localhost:${LOCAL_PORT};

.PHONY: open-url-github-pages
open-url-github-pages:  ## Open URL of application published on GitHub Pages
	@open https://filethis.github.io/${NAME};

.PHONY: print-url-github-pages
print-url-github-pages:  ## Print URL of application published on GitHub Pages
	@echo https://filethis.github.io/${NAME};


# Docs -----------------------------------------------------------------------------------

.PHONY: open-url-docs-local
open-url-docs-local:  ## Open URL of local application documentation
	@open file://`pwd`/docs/index.html;

.PHONY: print-url-docs-local
print-url-docs-local:  ## Print URL of local application documentation
	@echo file://`pwd`/docs/index.html;

.PHONY: open-url-docs-github-pages
open-url-docs-github-pages:  ## Open URL of application documentation published on GitHub Pages
	@open https://filethis.github.io/${NAME};

.PHONY: print-url-docs-github-pages
print-url-docs-github-pages:  ## Print URL of application documentation published on GitHub Pages
	@echo https://filethis.github.io/${NAME};


# Release -----------------------------------------------------------------------------------

.PHONY: publish-github-pages
publish-github-pages: build-app
	@bin_dir="$$(dirname `which gh-pages`)"; \
	parent_dir="$$(dirname $$bin_dir)"; \
	lib_dir=$$parent_dir/lib; \
	rm -rf $$lib_dir/node_modules/gh-pages/.cache; \
	gh-pages \
		--repo https://github.com/filethis/${NAME}.git \
		--branch gh-pages \
		--silent \
		--dist ./build/default; \
	echo Published version ${VERSION} of application \"${NAME}\" to GitHub Pages at https://filethis.github.io/${NAME};

#.PHONY: publish-github-pages
#publish-github-pages: build-app # Internal target: Publish application docs on GitHub Pages. Usually invoked as part of a release via 'release' target.
#	@bin_dir="$$(dirname `which gh-pages`)"; \
#	parent_dir="$$(dirname $$bin_dir)"; \
#	lib_dir=$$parent_dir/lib; \
#	rm -rf $$lib_dir/node_modules/gh-pages/.cache; \
#	gh-pages \
#		--repo https://github.com/filethis/${NAME}.git \
#		--branch gh-pages \
#		--dist ./docs/ \
#		--remove ./docs/README.md; \
#	echo Published documentation for version ${VERSION} of application \"${NAME}\" to GitHub Pages at https://filethis.github.io/${NAME};

.PHONY: bower-register
bower-register:  # Internal target: Register element in public Bower registry. Usually invoked as part of a release via 'release' target.
	@echo TODO: Should Polymer applications be registered in Bower?;



