#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
tmp_override="${tmp_dir}/comments-test-override.yml"
tmp_site="${tmp_dir}/site"

cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

cat >"${tmp_override}" <<'YAML'
giscus:
  repo: alshedivat/al-folio
  repo_id: R_kgDOExample
  category: Comments
  category_id: DIC_kwDOExample
YAML

bundle exec jekyll build --config "_config.yml,${tmp_override}" -d "${tmp_site}" >/dev/null

if [ -f "${giscus_page}" ]; then
  grep -q 'https://giscus.app/client.js' "${giscus_page}"
  if grep -q 'giscus comments misconfigured' "${giscus_page}"; then
    echo "unexpected giscus misconfiguration warning in ${giscus_page}" >&2
    exit 1
  fi
fi

if [ -f "${disqus_page}" ]; then
  grep -q 'id="disqus_thread"' "${disqus_page}"
  grep -q '.disqus.com/embed.js' "${disqus_page}"
fi

echo "comments integration checks passed"
