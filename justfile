@_default:
    just --list

@fmt:
    just --fmt --unstable

@pip-compile *ARGS:
    python -m pip install --upgrade pip pip-tools
    python -m pip install --upgrade -r requirements/requirements.in
    pip-compile {{ ARGS }}  \
        --resolver=backtracking \
        requirements/requirements.in

@pip-compile-upgrade:
    just pip-compile --upgrade

@pre-commit:
    pre-commit run --config=.pre-commit-config.yaml --all-files
