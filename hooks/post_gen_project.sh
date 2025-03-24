#!/usr/bin/env bash

git init
git add .
git commit -m "Initial commit"
git branch -M master
git remote add origin git@github.com:{{ cookiecutter.github_org }}/{{ cookiecutter.project_name }}
