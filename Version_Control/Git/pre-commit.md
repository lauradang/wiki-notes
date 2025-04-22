# Pre-Commit

Keep your code clean!

https://pre-commit.com/

To trigger this before a commit, be sure to run this first:

```bash
pre-commit install
```

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
    -   id: check-ast
    -   id: check-json
    -   id: check-toml
    -   id: debug-statements
    -   id: detect-aws-credentials
    -   id: detect-private-key
    -   id: pretty-format-json
        args: ['--no-sort-keys', '--autofix']
    -   id: no-commit-to-branch
        args: ['--branch', 'master']

-   repo: https://github.com/psf/black
    rev: 20.8b1
    hooks:
    -   id: black
-   repo: https://github.com/asottile/reorder_python_imports
    rev: v2.3.5
    hooks:
    -   id: reorder-python-imports
        args: [--py3-plus]
```

