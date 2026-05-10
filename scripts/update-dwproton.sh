#!/usr/bin/env bash
set -euo pipefail

release_api="${DWPROTON_RELEASE_API:-https://dawn.wine/api/v1/repos/dawn-winery/dwproton/releases/latest}"
package_file="${PACKAGE_FILE:-default.nix}"

release_json="$(curl -fsSL "$release_api")"
tag="$(jq -r '.tag_name // empty' <<<"$release_json")"

if [[ -z "$tag" || "$tag" != dwproton-* ]]; then
  echo "Could not determine latest DWProton release tag from $release_api" >&2
  exit 1
fi

version="${tag#dwproton-}"
asset_name="dwproton-${version}-x86_64.tar.xz"
asset_url="$(jq -r --arg name "$asset_name" '.assets[]? | select(.name == $name) | .browser_download_url' <<<"$release_json" | head -n1)"

if [[ -z "$asset_url" ]]; then
  echo "Could not find release asset $asset_name" >&2
  exit 1
fi

hash_json="$(nix store prefetch-file --unpack --hash-type sha256 --json "$asset_url")"
hash="$(jq -r '.hash // empty' <<<"$hash_json")"

if [[ -z "$hash" ]]; then
  echo "Could not determine Nix hash for $asset_url" >&2
  exit 1
fi

perl -0pi -e "s/version = \"[^\"]+\";/version = \"$version\";/" "$package_file"
perl -0pi -e "s|hash = \"[^\"]+\";|hash = \"$hash\";|" "$package_file"

echo "Updated DWProton to $version"
