# Repository Guidelines

## Project Structure & Module Organization

- `init.lua` loads `config` and toggles `exrc`/`secure`; treat it as the entry point.
- `lua/config` holds options, keymaps, env guards, and the Lazy bootstrap; plugin specs live in `lua/plugins`, LSP overrides in `lua/plugins/lsp`, helpers in `lua/util`.
- `after/`, `pack/plugins/start/luasnp`, and `dev/` checkouts (referenced by `config/lazy.lua`) load after Lazy, so keep them lean to avoid duplicate setups.

## Build, Test, and Development Commands

- Use `jj` for commits, rebases, and pushes; `make help` lists task shortcuts.
- `make lua-lint` and `make lua-lint-hook FILE=...` run `lua-language-server` globally or per file; treat either as the pre-commit gate.
- `nvim --headless "+Lazy! sync" +qa` refreshes plugins and lockfiles, while `nvim --headless "+checkhealth" +qa` verifies toolchain dependencies.

## Revision & Branch Workflow

- After each `main` push, rebase `testing` onto it locally and push the updated `testing` bookmark so GitHub mirrors your experiments.
- Start the next `latest updates` revision from `testing`, move `main` to it with `jj`, and keep the `latest updates` description for soon-to-ship work.
- Before the next push, rebase `latest updates` onto `main@origin` (the remote-tracking bookmark), move the `main` bookmark to that rebased revision, and only then push; after the push lands, repeat by rebasing/pushing `testing` and respawning `latest updates` from it.
- After `main` is moved and pushed, immediately rebase any other local branches onto that pushed `main` revision (not the new temporary `latest updates`) so they stay aligned before you resume work on them.
- When I say "ready to push" (or similar), execute the full flow interactively: (1) ensure the current revision has an accurate `jj desc`, (2) **CRITICAL: FIRST rebase the current revision onto `main@origin` with `jj rebase -r @ -d main@origin`** - do NOT skip this step or the push will have the wrong parent (testing instead of remote main); since `main` bookmark is already on @, it will move automatically with the rebase, (3) verify the rebase worked with `jj log -r 'ancestors(@, 3)'` to confirm @ is now based on main@origin and that main bookmark moved with it, (4) push with `jj git push -r main`, (5) **only if `testing` bookmark exists**: rebase `testing` onto the new main with `jj rebase -b testing -d main` and push testing with `jj git push -b testing`, (6) rebase other bookmarks (excluding `testing`) onto the pushed `main@origin` revision (not the new @), (7) spawn new `latest updates` from `testing` (if it exists) or from `main` (if testing doesn't exist) with `jj new <base> -m "latest updates"`, (8) move the `main` bookmark to the newly created `latest updates` revision with `jj bookmark set main -r @`. Halt and ask for guidance if any step hits conflicts.

## Coding Style & Naming Conventions

- Use tabs for indentation, double quotes for strings, trailing commas in tables, and keep lines ≤100 characters.
- Each plugin module returns a table named after its concern; place heavier logic in `config = function()` blocks with clear `desc` fields on mappings.
- Put shared helpers in `lua/util`, guard shell-outs with `vim.fn.executable` checks (see `kulala`), and isolate secrets or env-specific logic in `config/env.lua`.

## Testing Guidelines

- Run `make lua-lint` or targeted `make lua-lint-hook` before every commit; that's the minimum gate.
- Smoke test plugin specs with `nvim --headless "+lua require('lazy').stats()" +qa`.
- For LSP changes, open representative buffers headlessly (`nvim --headless +'e test.lua' +'LspInfo' +qa`) and log any regressions.

## Commit & Push Guidelines

- Keep every `jj desc` to a single-line Conventional Commit scope (e.g., `feat(lint): ...`) that reflects the full change set in the revision; add extra detail in the body only when needed.
- **Commit descriptions must comprehensively describe ALL changes in the diff** — review every modified file and summarize all changes, not just a subset. Use bullet points in the body to enumerate changes across multiple files or subsystems.
- Create, amend, and reorder commits with `jj` so the repository's preferred DVCS remains the source of truth before exporting to Git remotes.
- When `lazy-lock.json` changes intentionally, keep that bump in its own commit so lock diffs stay readable.
