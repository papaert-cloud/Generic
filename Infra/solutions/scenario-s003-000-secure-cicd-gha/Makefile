PYTHON=python3

.PHONY: build upload test

build:
	./build.sh

upload:
	# usage: make upload S3_BUCKET=my-bucket
	./upload.sh $(S3_BUCKET) $(S3_KEY)

test:
	$(PYTHON) -m pytest -q lambda/test_remediate.py
