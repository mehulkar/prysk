PYTHON=python

ifdef PREFIX
PREFIX_ARG=--prefix=$(PREFIX)
endif

all: build

build:
	$(PYTHON) setup.py build

clean:
	-$(PYTHON) setup.py clean --all
	find . -not -path '*/.hg/*' \( -name '*.py[cdo]' -o -name '*.err' -o \
		-name '*,cover' -o -name __pycache__ \) -prune \
		-exec rm -rf '{}' ';'
	rm -rf dist build htmlcov
	rm -f README.md MANIFEST .coverage cram.xml

install: build
	$(PYTHON) setup.py install $(PREFIX_ARG)

dist:
	TAR_OPTIONS="--owner=root --group=root --mode=u+w,go-w,a+rX-s" \
	$(PYTHON) setup.py -q sdist

test:
ifeq ($(PYTHON),all)
	python2.4 -tt setup.py -q test $(TEST_ARGS)
	python2.5 -tt setup.py -q test $(TEST_ARGS)
	python2.6 -tt -3 setup.py -q test $(TEST_ARGS)
	python2.7 -tt -3 setup.py -q test $(TEST_ARGS)
	python3.2 -tt -bb setup.py -q test $(TEST_ARGS)
	python3.3 -tt -bb setup.py -q test $(TEST_ARGS)
	python3.4 -tt -bb setup.py -q test $(TEST_ARGS)
else
	$(PYTHON) setup.py -q test $(TEST_ARGS)
endif

tests: test

coverage:
	$(PYTHON) setup.py -q test --coverage && \
	coverage report && \
	coverage annotate

# E261: two spaces before inline comment
# E301: expected blank line
# E302: two new lines between functions/etc.
pep8:
	pep8 --ignore=E125,E261,E301,E302 --repeat cram setup.py

pyflakes:
	pyflakes cram setup.py

pylint:
	pylint --rcfile=.pylintrc cram setup.py

markdown:
	pandoc -f rst -t markdown README.rst > README.md

.PHONY: all build clean install dist test tests coverage pep8 pyflakes \
	pylint markdown
