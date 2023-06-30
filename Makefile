GRADLE := gradle

.PHONY: clean
clean:
	rm -rf build

.PHONY: build
build: clean
	$(GRADLE) build

