#!/usr/bin/env bash

git init
make codestyle
make distclean
git add .
git commit -m "Initial commit"
git branch -M master
git remote add origin git@github.com:{{ cookiecutter.owner }}/{{ cookiecutter.project_name }}
