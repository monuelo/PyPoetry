# PyPoetry
An Action for python dependency management and packaging with Poetry

## Usage
```yml
name: Build and Test
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Install Dependencies
      uses: hericlesme/PyPoetry@master
      with:
        python_version: 3.8.0
        poetry_version: 1.0
        args: install
        workdir: ./projects/my_python_package
    - name: Test
        ...
```

### Arguments

#### Required
- `command` - the Poetry command to be executed.

#### Optional
- `workdir` - the working directory for Poetry. (default: '.')
- `create_venv` - tells poetry to create a new virtual environment (default: false)
- `python_version` - the Python version to be installed. (default: 3.8)
- `poetry_version` - the Poetry version to be installed. (default: 1.0)

## License

[Apache License 2.0](https://github.com/hericlesme/PyPoetry/blob/master/LICENSE)
