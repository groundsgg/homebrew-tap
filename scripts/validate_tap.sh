#!/usr/bin/env bash
set -euo pipefail

FORMULA_PATH="grounds.rb"

if [[ ! -f "${FORMULA_PATH}" ]]; then
  echo "Validation failed: missing ${FORMULA_PATH}"
  exit 1
fi

extract_version() {
  local file_path="$1"
  awk -F'"' '/^[[:space:]]*version "/ { print $2; exit }' "${file_path}"
}

ensure_contains() {
  local file_path="$1"
  local expected_text="$2"
  if ! grep -Fq "${expected_text}" "${file_path}"; then
    echo "Validation failed: expected text not found in ${file_path}: ${expected_text}"
    exit 1
  fi
}

ensure_count_at_least() {
  local file_path="$1"
  local pattern="$2"
  local minimum_count="$3"
  local actual_count
  if ! actual_count="$(grep -cE "${pattern}" "${file_path}")"; then
    actual_count="0"
  fi
  if (( actual_count < minimum_count )); then
    echo "Validation failed: ${file_path} has ${actual_count} matches for '${pattern}', expected at least ${minimum_count}"
    exit 1
  fi
}

formula_version="$(extract_version "${FORMULA_PATH}")"

if [[ -z "${formula_version}" ]]; then
  echo "Validation failed: could not read version from formula"
  exit 1
fi

ensure_contains "${FORMULA_PATH}" "on_macos do"
ensure_contains "${FORMULA_PATH}" "on_linux do"
ensure_contains "${FORMULA_PATH}" "Hardware::CPU.intel?"
ensure_contains "${FORMULA_PATH}" "Hardware::CPU.arm?"
ensure_count_at_least "${FORMULA_PATH}" '^[[:space:]]*sha256 "' 4

ensure_contains "${FORMULA_PATH}" "releases/download/v${formula_version}/grounds-cli_${formula_version}_darwin_amd64.tar.gz"
ensure_contains "${FORMULA_PATH}" "releases/download/v${formula_version}/grounds-cli_${formula_version}_darwin_arm64.tar.gz"
ensure_contains "${FORMULA_PATH}" "releases/download/v${formula_version}/grounds-cli_${formula_version}_linux_amd64.tar.gz"
ensure_contains "${FORMULA_PATH}" "releases/download/v${formula_version}/grounds-cli_${formula_version}_linux_arm64.tar.gz"

echo "Tap validation passed (version=${formula_version})"
