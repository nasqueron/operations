#   -------------------------------------------------------------
#   Helper utilities for tests suite
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Helper methods to help to JSON Schema
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

import re
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator
from jsonschema.exceptions import SchemaError, ValidationError
import yaml

REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
PILLAR_ROOT = REPOSITORY_ROOT / "pillar"
SCHEMAS_ROOT = REPOSITORY_ROOT / "_resources" / "schemas" / "pillar"

JSONPATH_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
SCHEMA_SUFFIXES = (".schema.json", ".json", ".yaml", ".yml")


def load_yaml_file(file_path: Path) -> Any:
    with file_path.open(encoding="utf-8") as fd:
        data = yaml.load(fd, Loader=yaml.SafeLoader)

    return {} if data is None else data


def resolve_schema_path(schema_name: str) -> Path:
    schema_path = SCHEMAS_ROOT / schema_name

    if schema_path.suffix:
        if not schema_path.is_file():
            raise FileNotFoundError(
                f"Schema {schema_name!r} not found at "
                f"{schema_path.relative_to(REPOSITORY_ROOT)}"
            )
        return schema_path

    candidates = []
    for suffix in SCHEMA_SUFFIXES:
        candidate = schema_path.with_name(schema_path.name + suffix)
        candidates.append(candidate)

        if candidate.is_file():
            return candidate

    tried_paths = ", ".join(
        str(candidate.relative_to(REPOSITORY_ROOT)) for candidate in candidates
    )
    raise FileNotFoundError(f"Schema {schema_name!r} not found. Tried: {tried_paths}")


def load_schema(schema_name: str) -> Any:
    return load_yaml_file(resolve_schema_path(schema_name))


def find_sls_files(path: Path) -> list[Path]:
    return sorted(p for p in path.rglob("*.sls") if p.is_file())


def format_json_path(error: ValidationError) -> str:
    if not error.absolute_path:
        return "$"

    path = "$"

    for segment in error.absolute_path:
        if isinstance(segment, int):
            path += f"[{segment}]"
        elif JSONPATH_IDENTIFIER.match(str(segment)):
            path += f".{segment}"
        else:
            escaped_segment = str(segment).replace("\\", "\\\\").replace("'", "\\'")
            path += f"['{escaped_segment}']"

    return path


def sort_path_segments(error: ValidationError) -> list[tuple[int, Any]]:
    """
    Build a type-aware sort key for a validation error path.

    Integers are sorted numerically, strings lexically, and the leading type
    rank avoids direct int/str comparisons.
    """
    return [
        (0, segment) if isinstance(segment, int) else (1, str(segment))
        for segment in error.absolute_path
    ]


def assert_matches_schema(
    test_case: Any, pillar_file_path: Path, schema_name: str
) -> None:
    pillar_file_path = Path(pillar_file_path).resolve()
    schema_path = resolve_schema_path(schema_name)
    schema = load_yaml_file(schema_path)

    relative_schema = schema_path.relative_to(REPOSITORY_ROOT)

    try:
        Draft202012Validator.check_schema(schema)
    except SchemaError as error:
        test_case.fail(
            f"{relative_schema} is not a valid JSON Schema: " f"{error.message}"
        )

    validator = Draft202012Validator(schema)
    pillar = load_yaml_file(pillar_file_path)

    errors = sorted(
        validator.iter_errors(pillar),
        key=sort_path_segments,
    )

    if not errors:
        return

    relative_pillar = pillar_file_path.relative_to(REPOSITORY_ROOT)

    formatted_errors = [
        f"{relative_pillar}: {format_json_path(error)}: {error.message}"
        for error in errors
    ]

    test_case.fail(
        "\n".join(
            [
                f"{relative_pillar} doesn't match {relative_schema}:",
                *formatted_errors,
            ]
        )
    )
