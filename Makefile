.PHONY: clean lint test coverage release-local dist release-staging release-staging-release-commit release-staging-minor docs docs-server changelog
IPY=python -c
PACKAGE_NAME=emodpy
PY?=python
PDS=$(PY) ./.dev_scripts/
PDR=$(PDS)run.py
CLDIR=$(PDS)clean_dir.py
CWD=$($(IPY) "import os; print(os.getcwd())")
TEST_COMMAND=py.test --durations=3 -v --junitxml=test_results.xml
TEST_RUN_OPTS=-e DOCKER_REPO=idm-docker-staging NO_SPINNER=1
FULL_TEST_CMD=$(PDR) -w 'tests' $(TEST_RUN_OPTS) -ex '$(TEST_COMMAND)
COVERAGE_CMD=$(PDR) -w 'tests' $(TEST_RUN_OPTS) -p . ../ -ex 'coverage run --omit="*/test*,*/setup.py" --source ../,../../idmtools_core,../../idmtools_platform_local,../../idmtools_platform_comps,../../idmtools_models,../../idmtools_model_emod -m pytest

help:
	$(PDS)get_help_from_makefile.py

setup-dev:  ## Setup packages in dev mode
	python ./.dev_scripts/bootstrap.py

clean: ## Clean most of the temp-data from the project
	$(CLDIR) --file-patterns "*.py[co],*.done,*.log,**/.coverage" \
		--dir-patterns "**/__pycache__,**/htmlcov,**/.pytest_cache" --directories "dist,build"
	$(PDR) -wd "docs" -ex "make clean"

clean-all:  ## Deleting package info hides plugins so we only want to do that for packaging
	@make clean
	$(CLDIR) --dir-patterns "**/*.egg-info/"

lint: ## check style with flake8 - E201,E202,E501,W291,W503,E261
	flake8 --ignore=E501,E261,W503 --exclude="emodpy/tests/**" $(PACKAGE_NAME)

test: ## Run our tests
	$(FULL_TEST_CMD) -m "not comps and not docker"'

test-all: ## Run all our tests
	$(FULL_TEST_CMD)' -rt 0

test-emod: ## Run our emod tests
	$(FULL_TEST_CMD) -m "emod"'

test-failed: ## Run only previously failed tests
	$(FULL_TEST_CMD) --lf'

test-long: ## Run any tests that takes more than 30s
	$(FULL_TEST_CMD) -m "long"'

test-no-long: ## Run any tests that takes less than 30s
	$(FULL_TEST_CMD) -m "not long"'

test-comps: ## Run our comps tests
	$(FULL_TEST_CMD) -m "comps"'

test-docker: ## Run our docker tests
	$(FULL_TEST_CMD) -m "docker"'

test-ssmt: ## Run our ssmt tests
	$(FULL_TEST_CMD) -m "ssmt"'

test-smoke: ## Run our smoke tests
	$(FULL_TEST_CMD) -m "smoke"'

coverage: ## Generate a code-coverage report
	@make clean
	# We have to run in our tests folder to use the proper config
	$(COVERAGE_CMD) -m "not comps and not docker"'
	@+$(IPY) "import shutil as s; s.move('tests/.coverage','.coverage')"
	coverage report -m
	coverage html -i
	$(PDS)/launch_dir_in_browser.py htmlcov/index.html

coverage-all: ## Generate a code-coverage report using all tests
	# We have to run in our tests folder to use the proper config
	$(COVERAGE_CMD)
	@+$(IPY) "import shutil as s; s.move('tests/.coverage','.coverage')"
	coverage report -m
	coverage html -i
	$(PDS)/launch_dir_in_browser.py htmlcov/index.html

# Release
dist: ## build our package using pyproject.toml file
	@make clean
	pip install build
	python -m build --wheel

release-staging: ## perform a release to staging
	@make dist
	twine upload --verbose --repository-url https://packages.idmod.org/api/pypi/idm-pypi-staging/ dist/*

bump-release: ## bump the release version.
	bump2version release --commit

# Use before release-staging-release-commit to confirm next version.
bump-release-dry-run: ## bump the release version. (dry run)
	bump2version release --dry-run --allow-dirty --verbose

bump-patch: ## bump the patch version
	bump2version patch --commit

bump-minor: ## bump the minor version
	bump2version minor --commit

bump-major: ## bump the major version
	bump2version major --commit

bump-patch-dry-run: ## bump the patch version(dry run)
	bump2version patch --dry-run --allow-dirty --verbose

bump-minor-dry-run: ## bump the minor version(dry run)
	bump2version minor --dry-run --allow-dirty --verbose

bump-major-dry-run: ## bump the major version(dry run)
	bump2version major --dry-run --allow-dirty --verbose

docs: ## build docs(only works on linux at moment due to make.bat not running by default)
	$(PDR) -wd 'docs' -ex 'make html'

docs-server: ## builds docs and launch a webserver
	@make build-docs
	@+$(IPY) "print('Serving documentation @ server at http://localhost:8000 . Ctrl + C Will Stop Server')"
	$(PDR) -wd 'docs/_build/html' -ex 'python -m http.server'

changelog: ## Generate partial changelog
	$(PDS)changelog.py
