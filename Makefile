# Makefile
GITHUB_REPO ?= cmcavoy/openbadges-displayer.js

# Sends the documentation to gh-pages.
demoDeploy: buildDemoSite
	cd demoSite && \
	git init . && \
	git add . && \
	git commit -m "Update demosite."; \
	git push "git@github.com:$(GITHUB_REPO).git" master:gh-pages --force && \
	rm -rf .git

build:
	rm -rf build
	mkdir build
	./node_modules/.bin/browserify ./src/index.js -o build/openbadgesDisplay.js

buildDemoSite: build
	rm -rf demoSite
	mkdir demoSite
	cp resources/* demoSite
	mkdir demoSite/build
	cp build/* demoSite/build

server:
	static .

devserver:
	beefy --cwd resources ../src/index.js:build/openbadgesDisplay.js --live

.PHONY: build buildDev server run devserver demoDeploy
