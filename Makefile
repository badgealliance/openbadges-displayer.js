build:
	./node_modules/.bin/browserify ./src/index.js -o distrib/openbadgesDisplay.js

buildDev:
	./node_modules/.bin/browserify ./src/index.js -d -o build/openbadgesDisplay.js

buildDemoSite:
	cp resources/* .

server:
	static .

devserver:
	beefy src/index.js:build/openbadgesDisplay.js --live

run: buildDev server

.PHONY: build buildDev server run devserver
