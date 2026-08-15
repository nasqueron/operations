## Salt Code Conventions

These conventions apply to Salt state and configuration-management code in this repository.

### State dependencies

Salt executes states in file order, so execution order within an SLS file is deterministic.

Do **not** add `require`, `watch`, `onchanges`, or similar requisites merely to express the dependency between successive states in the same file.

Prefer the simplest code that relies on the file's execution order.

Use requisites when they provide actual behavior that cannot be expressed by file order, especially when a service must be reloaded or restarted when its configuration changes.

For example, if a configuration file should trigger a service reload when changed, use an appropriate requisite rather than relying only on the order of the states.

### Managed file contents

For `file.managed`, store repository-managed file contents in the corresponding `files/` directory.

Do **not** put file contents directly in the `contents` parameter when the content belongs in the repository.

Add a header to repository-managed files that clearly identifies them as being managed by this repository.

For example:

```yaml
/etc/example.conf:
  file.managed:
    - source: salt://path/to/files/example.conf
```

with the repository file containing an appropriate repository-management header.

### Template file extensions

When a file is a template, normally preserve the original file extension.

For example:

```text
files/foo.conf
files/script.sh
files/config.yaml
```

If adding Jinja syntax would cause the file to be incorrectly handled by a shell, Python, YAML, or other language linter, append `.jinja` to the original extension:

```text
files/foo.sh.jinja
files/config.yaml.jinja
```

Use `.jinja`, **not `.j2`**.

The extension in the repository should reflect the language of the deployed file. When a command or script is deployed without its source-language extension, keep the language extension in the repository but omit it from the deployed filename.

For example:

```text
files/foo.sh
```

may be deployed as:

```text
/usr/local/bin/foo
```

### State block names

When a state deploys a file to a specific path, use that destination path as the state ID.

For example:

```yaml
/etc/example/example.conf:
  file.managed:
    - source: salt://example/files/example.conf
```

The state ID is therefore the actual path being managed.

Do not introduce an arbitrary descriptive state ID such as:

```yaml
deploy_example_config:
  file.managed:
    - name: /etc/example/example.conf
```

when the state manages a file at a precise path.

The state ID is implicitly the `name` parameter when `name` is not specified, so using the path directly keeps the state concise and makes the managed resource immediately visible.

Use a descriptive state ID when there are duplicates.

### Template variables

Make template variables visible from the .sls file that uses the template.

Do **not** query Pillar data, grains, or Salt functions directly from inside a Jinja template.

Instead, resolve the values in the `context` of the `file.managed` state and pass them explicitly to the template.

Prefer:

```yaml
/etc/example/example.conf:
  file.managed:
    - source: salt://example/files/example.conf.jinja
    - context:
        hostname: {{ grains['host'] }}
        setting: {{ pillar['example']['setting'] }}
```

with the template using:

```jinja
hostname = {{ hostname }}
setting = {{ setting }}
```

rather than having the template directly access:

```jinja
{{ grains['host'] }}
{{ pillar['example']['setting'] }}
```

or invoke Salt functions itself.

This makes the inputs to a template visible where the state is declared, simplifies the template, and makes dependencies on external Salt data explicit.
