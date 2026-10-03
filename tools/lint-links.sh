#!/usr/bin/env bash
# Link audit for THE UNOWNABLE CENTER wiki.
# Reports broken wikilinks, duplicate filenames, and orphan pages.
set -u
cd "$(dirname "$0")/.." || exit 1

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Every page's basename (Obsidian resolves by filename, not path)
find wiki -name '*.md' -printf '%f\n' | sed 's/\.md$//' | sort > "$TMP/pages"

# Every wikilink target, stripping |alias and #heading
# inline code spans (`...`) are documentation, not links: strip them first
find wiki -name '*.md' -print0 | xargs -0 cat | sed 's/`[^`]*`//g' | grep -o '\[\[[^]]*\]\]' \
  | sed 's/^\[\[//; s/\]\]$//; s/|.*$//; s/#.*$//' \
  | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//' \
  | sort -u > "$TMP/links"

echo "=== pages: $(wc -l < "$TMP/pages")   distinct link targets: $(wc -l < "$TMP/links") ==="

echo
echo "--- BROKEN LINKS (target has no page) ---"
BROKEN=$(comm -23 "$TMP/links" <(sort -u "$TMP/pages"))
if [ -z "$BROKEN" ]; then echo "none"; else
  echo "$BROKEN" | while IFS= read -r t; do
    [ -z "$t" ] && continue
    printf '%-45s <- ' "$t"
    grep -rl "\[\[$t\(\]\]\||\)" wiki --include='*.md' 2>/dev/null | head -3 | tr '\n' ' '
    echo
  done
fi

echo
echo "--- DUPLICATE FILENAMES ---"
DUP=$(sort "$TMP/pages" | uniq -d)
[ -z "$DUP" ] && echo "none" || echo "$DUP"

echo
echo "--- ORPHANS (no inbound link) ---"
FOUND=0
while IFS= read -r p; do
  [ "$p" = "index" ] && continue
  [ "$p" = "log" ] && continue
  [ "$p" = "Overview" ] && continue
  if ! grep -q "^$p$" "$TMP/links"; then echo "$p"; FOUND=1; fi
done < "$TMP/pages"
[ "$FOUND" -eq 0 ] && echo "none"
