#!/bin/bash
set -e

main() {

  # Check existence of required inputs
  sanitize "${INPUT_COMMAND}" "command"

  # Install dependencies (Poetry and Python)
  installDependencies

  # Change workdir (if provided)
  if uses "${INPUT_WORKDIR}"; then
    changeWorkingDirectory
  fi

  # Fallback for local virtual environments defined in .python-version file
  pyenv latest local "$INPUT_PYTHON_VERSION"

  # Check working env
  if ! (usesBoolean "${INPUT_CREATE_VENV}"); then
    sh -c poetry config virtualenvs.create false
  fi

  # Execute poetry with given arguments
  runPoetry

  # Delete all __pycache__ files
  cleanCache

  # Reset working directory
  resetWorkingDirectory
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

changeWorkingDirectory() {
  pushd . > /dev/null 2>&1 || return
  cd "${INPUT_WORKDIR}"
}

resetWorkingDirectory() {
  popd > /dev/null 2>&1 || return
}

cleanCache() {
  find . -type d -name  "__pycache__" -exec rm -r {} +
}

runPoetry() {
    sh -c "poetry "${INPUT_COMMAND}""
}

installDependencies(){
  pyenv latest install "$INPUT_PYTHON_VERSION"
  pyenv latest global "$INPUT_PYTHON_VERSION"
  pip install --upgrade pip
  pip install poetry=="$INPUT_POETRY_VERSION"
  pyenv rehash
}

uses() {
  [ ! -z "${1}" ]
}

usesBoolean() {
  [ ! -z "${1}" ] && [ "${1}" = "true" ]
}

main
