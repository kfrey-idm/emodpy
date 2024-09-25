![Staging: emodpy](https://github.com/InstituteforDiseaseModeling/emodpy-idmtools/workflows/Staging:%20emodpy/badge.svg)

# emodpy

*STILL IN DEVELOPEMENT*

Documentation available at https://docs.idmod.org/projects/emodpy/en/latest/.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [User Installation](#user-installation)
  - [Pre-requisites](#pre-requisites)
- [Development Environment Setup](#development-environment-setup)
  - [First Time Setup](#first-time-setup)
  - [Development Tips](#development-tips)
  - [To run examples or tests](#to-run-examples-or-tests)
  - [Building docs](#building-docs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# User Installation

```bash
pip install emodpy --index-url=https://packages.idmod.org/api/pypi/pypi-production/simple
```

## Pre-requisites
- Python 3.6/3.7 x64


# Development Environment Setup

When setting up your environment for the first time, you can use the following instructions

## First Time Setup
1) Clone the repository:
   ```bash
   > git clone https://github.com/InstituteforDiseaseModeling/emodpy.git
   ```
2) Create a virtualenv. On Windows, please use venv to create the environment
   `python -m venv idmtools`
   On Unix(Mac/Linux) you can use venv or virtualenv
3) Activate the virtualenv
4) If you are on windows, run `pip install py-make --upgrade --force-reinstall`
5) Then run `python ./.dev_scripts/bootstrap.py`. This will install all the tools. 

## Development Tips

There is a Makefile file available for most common development tasks. Here is a list of commands
```bash
clean       -   Clean up temproary files
lint        -   Lint package and tests
test        -   Run All tests
coverage    -   Run tests and generate coverage report that is shown in browser
```
On Windows, you can use `pymake` instead of `make`

## To run examples or tests

First, install idmtools packages including emodpy package from idm artifactory

staging artifactory with nightly build packages:
```bash
pip install idmtools[idm] --index-url=https://email:password@packages.idmod.org/api/pypi/pypi-staging/simple
OR
pip install idmtools[full] --index-url=https://email:password@packages.idmod.org/api/pypi/pypi-staging/simple
```
[idm] option will install all idmtools packages except idmtools_platform_local package

[full] option will install all idmtools packages including idmtools_platform_local package

email:password is your company login credentials. password should be encoded for specially characters

production artifactory with latest release packages:
```bash
pip install idmtools[idm] --index-url=https://packages.idmod.org/api/pypi/pypi-production/simple
OR
pip install idmtools[full] --index-url=https://packages.idmod.org/api/pypi/pypi-production/simple
```
To run integration tests or examples, you also need to install idmtools-test package
```bash
pip install idmtools-test --index-url=https://email:password@packages.idmod.org/api/pypi/pypi-staging/simple
OR
pip install idmtools-test --index-url=https://packages.idmod.org/api/pypi/pypi-production/simple
```

## Building docs

Install all necessary documentation tools using ``pip install -r doc/requirements.txt`` and install emodpy in the same environment. Navigate to the docs folder and enter ``make html``. If you make updates to the docstrings, you must reinstall emodpy to pick up the latest changes in the documentation build. It's also good practice to run ``make clean`` before rebuilding the documentation to avoid missing errors or warnings. These steps are only for testing the build locally before committing changes. The documentation build on Read the Docs will run automatically when new code is committed. 
