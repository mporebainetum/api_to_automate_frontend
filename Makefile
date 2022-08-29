.PHONY: build_front_image
all: build_front_image
#.DEFAULT_GOAL := clean
build_front_image:
	@echo "Frontend image building"
	@docker build --tag frontend:latest .
	@echo "Frontend image has been build"
