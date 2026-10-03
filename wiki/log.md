---
type: map
title: "log"
aliases: ["Log"]
updated: 2026-10-03
---

# log

Append only. Newest at the bottom. Each entry starts `## [date] kind | subject` so it can be searched:

```bash
grep "^## \[" wiki/log.md | tail -5
```

The method's Drive log (`LOGS/LOG_<date>_unownable-editor-steward.md`) is kept as well, because the other stewards read Drive.

## [2026-09-30] ingest | first session (before this wiki existed)

Filed in Drive as `LOG_2026-09-30_unownable-editor-steward.md` (`1LL09T_dj2bI8bwajP_p0WiLVHrzkLeGt`). Read the opening ruling, the method, the protocol, and Grok's audit. Confirmed the three Drive copies at 81,091 bytes. Found the public GitHub repo through Grok's audit and put it to Ammon. Touched no manuscript file.

## [2026-10-02] ruling | Ammon: work this book in its GitHub repo, as a wiki

Recorded in [[Rulings]], with his words and the steward's reading.

## [2026-10-03] ruling | the series wiki repo is renamed

`wikiammon` is now `ammoncovino/alpha-omega-wiki`. Recorded in [[Rulings]].

## [2026-10-03] build | first build of this wiki

- Cloned this repo (commit `306a6528`, 21 June) and the series wiki (read only) for its pattern.
- Verified `manuscript/complete-recovered-draft.md`: 81,091 bytes, md5 `ee24e9c0af82c281ebd94dd00c3286d8`, sha256 `58711fcd...a152d2d`. Matches Grok's hash of the September Drive copy. **The repo copy is now hashed from a real file**, which the 30 Sept log could not do.
- Read the recovered draft in full. Exported the reading draft from Drive to `raw/reading-draft_8Aug2026.md` and compared the two by script: the prose is identical. Copied the handoff to `raw/`.
- Wrote `CLAUDE.md` (schema), adapted `tools/` from the series wiki, and wrote 52 pages: 22 section pages (counts and lines by script), 3 sources, 8 concepts, 11 threads, and 8 maps and entry points, including this log and the generated index.
- **What I got wrong, and fixed before anything was pushed:**
  1. The first generated section pages marked all eleven outlines as "full prose," because their recovery comment reads "full prose not recovered." Fixed the check; counts now 8, 11, 1, 2, matching the handoff.
  2. I typed the residue label counts from memory (34; "Recovered structural placement" 9; "Bridge" 6). Measured: 35; 10; 5. Replaced with measured counts.
  3. I wrote the repo's creation date as 21 June. GitHub says created 26 May, last pushed 21 June. Corrected.
  4. I first wrote row 13 of the promises table as holding in both orders. It holds in the recovered order only. Corrected.
- Did not touch: `manuscript/`, `README.md`, `RECOVERY_NOTES.md`, `LICENSE.md`. Did not push. Did not change the repo's visibility.
- Waiting on Ammon: G0, whether to push while the repo is public.
- **Found and fixed in this repo's copy of `tools/build-github-wiki.sh`:** in `repo` mode it renamed `index.md` and `log.md` to `Index.md` and `Log.md` but left links pointing at the lowercase names, which break on GitHub. After the fix: 424 links in the render, 0 broken.
- **Handed over, not fixed:** the series wiki's `tools/build-github-wiki.sh` (`ammoncovino/alpha-omega-wiki`) has the same bug. Not this steward's file. For whoever keeps that wiki.
- Checks run: manuscript hash unchanged; no tracked file changed; link audit clean (52 pages, 0 broken, 0 orphans); no em dashes or contractions outside quotations; the nine-word title rule holds.

## [2026-10-03] ruling | G0: make the repo private, collaborators only

Ammon, 12:20 CT: "Make it private only shared with collaboration." Tried to set visibility through the GitHub API: refused, "Repository settings writes are not permitted through this proxy" (HTTP 403). The collaborator list cannot be read from here either. Visibility at 12:2x CT: still `public`. **Not pushed.** Push follows once the API reports `private`.

## [2026-10-03] ruling | G0 reversed: leave the repo public, push the wiki

Ammon, 13:04 CT: "Leave it public." The 12:20 ruling to make it private is superseded; it was never carried out. Pushed branch `wiki-first-build` to the repo. Not merged into `main`: the steward does not merge.
- 13:04 CT, Ammon: "I want people to have this." Opened pull request #1 (`wiki-first-build` into `main`) so the wiki shows on the repo's front page once Ammon merges it.
