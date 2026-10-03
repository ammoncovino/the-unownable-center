#!/usr/bin/env bash
# Render the Obsidian vault as a GitHub-readable wiki.
#
#   bash tools/build-github-wiki.sh repo          -> gh-wiki/ with [text](Page.md) links,
#                                                    browsable in the repo file view
#   bash tools/build-github-wiki.sh wiki          -> gh-wiki/ keeping [[Page]] links, which
#                                                    GitHub's own wiki engine resolves
#   bash tools/build-github-wiki.sh wiki --push   -> also push to <repo>.wiki.git
#
# Pages are flattened into one directory. That is safe here only because
# tools/lint-links.sh reports any duplicate filename; run it first.
set -eu
cd "$(dirname "$0")/.." || exit 1

MODE="${1:-repo}"
PUSH="${2:-}"
OUT=gh-wiki
rm -rf "$OUT"; mkdir -p "$OUT"

urlenc() { printf '%s' "$1" | sed 's/ /%20/g'; }

# \x5c is a literal backslash. Obsidian escapes pipes inside tables, so a page
# name captured from [[Page\|alias]] can arrive with a trailing backslash.
CONV='
  s{\[\[([^\]|#]+?)(?:#[^\]|]*)?\|([^\]]+?)\]\]}{
    my ($pg, $al) = ($1, $2);
    $pg =~ s/\x5c+$//;
    my $u = $pg; $u =~ s/ /%20/g;
    "[" . $al . "](" . $u . ".md)"
  }ge;
  s{\[\[([^\]|#]+?)(?:#[^\]|]*)?\]\]}{
    my $pg = $1;
    $pg =~ s/\x5c+$//;
    my $u = $pg; $u =~ s/ /%20/g;
    "[" . $pg . "](" . $u . ".md)"
  }ge;
'

convert() {  # $1 = source, $2 = destination
  local src="$1" dst="$2"
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$src" > "$dst.tmp"
  if [ "$MODE" = "repo" ]; then
    # index.md and log.md are renamed Index.md and Log.md below; GitHub paths are
    # case-sensitive, so the links must follow the rename.
    perl -pe "$CONV" "$dst.tmp" | sed 's/](index\.md)/](Index.md)/g; s/](log\.md)/](Log.md)/g' > "$dst"
  else
    cp "$dst.tmp" "$dst"
  fi
  rm -f "$dst.tmp"
}

COUNT=0
while IFS= read -r f; do
  name=$(basename "$f")
  [ "$name" = "index.md" ] && name="Index.md"
  [ "$name" = "log.md" ] && name="Log.md"
  convert "$f" "$OUT/$name"
  COUNT=$((COUNT + 1))
done < <(find wiki -name '*.md')

[ -f "$OUT/Overview.md" ] && cp "$OUT/Overview.md" "$OUT/Home.md"

{
  echo "### The Unownable Center"; echo
  for p in Home Rulings "Open Questions" "Work Plan" "Section Map" Records Index Log; do
    [ -f "$OUT/$p.md" ] || continue
    if [ "$MODE" = "repo" ]; then echo "- [$p]($(urlenc "$p").md)"; else echo "- [[$p]]"; fi
  done
  echo; echo "### The drafts"; echo
  for p in "Recovered Draft" "Reading Draft"; do
    [ -f "$OUT/$p.md" ] || continue
    if [ "$MODE" = "repo" ]; then echo "- [$p]($(urlenc "$p").md)"; else echo "- [[$p]]"; fi
  done
} > "$OUT/_Sidebar.md"

echo "built $OUT/ — $COUNT pages, mode=$MODE"

if [ "$PUSH" = "--push" ]; then
  REMOTE=$(git remote get-url origin | sed 's/\.git$//').wiki.git
  if ! git ls-remote "$REMOTE" >/dev/null 2>&1; then
    echo "ERROR: $REMOTE does not exist."
    echo "Enable the repo's Wiki first. On a PRIVATE repo that needs a paid plan"
    echo "(Pro/Team/Enterprise). On a public repo, open the Wiki tab, create the first page"
    echo "once, and this script can push from then on."
    exit 1
  fi
  ( cd "$OUT" && git init -q && git add -A \
      && git -c commit.gpgsign=false commit -q -m "Publish wiki from Obsidian vault" \
      && git push -q --force "$REMOTE" HEAD:master )
  echo "pushed to $REMOTE"
fi
