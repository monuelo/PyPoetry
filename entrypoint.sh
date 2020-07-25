#!/bin/bash
set -e

function main() {
  echo "" 

  # Check existence of required inputs
  sanitize "${INPUT_PYTHON_VERSION}" "python version"
  sanitize "${INPUT_POETRY_VERSION}" "poetry version"

  # Install dependencies (Poetry and Python)
  installDependencies

  # Change workdir (if provided)
  if uses "${INPUT_WORKDIR}"; then
    changeWorkingDirectory
  fi

  # Fallback for local virtual environments defined in .python-version file
  pyenv latest local "$INPUT_PYTHON_VERSION"

  # Execute poetry with given arguments
  runPoetry

  # Delete all __pycache__ files
  cleanCache

  # Reset working directory
  resetWorkingDirectory
}

function sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

function changeWorkingDirectory() {
  pushd . > /dev/null 2>&1 || return
  cd "${INPUT_WORKDIR}"
}

function resetWorkingDirectory() {
  popd > /dev/null 2>&1 || return
}

function cleanCache() {
  find . -type d -name  "__pycache__" -exec rm -r {} +
}

function runPoetry() {
    sh -c "poetry $*"
}

function installDependencies(){
  pyenv latest install "$INPUT_PYTHON_VERSION"
  pyenv latest global "$INPUT_PYTHON_VERSION"
  pip install -r /requirements.txt
  pip install poetry=="$INPUT_POETRY_VERSION"
  pyenv rehash
}

main
