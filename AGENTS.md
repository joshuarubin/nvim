# Repository Guidelines

## Project Structure & Module Organization

- `init.lua` loads `config` and toggles `exrc`/`secure`; treat it as the entry point.
- `lua/config` holds options, keymaps, env guards, and the Lazy bootstrap; plugin specs live in `lua/plugins`, LSP overrides in `lua/plugins/lsp`, helpers in `lua/util`.
- `after/`, `pack/plugins/start/luasnp`, and `dev/` checkouts (referenced by `config/lazy.lua`) load after Lazy, so keep them lean to avoid duplicate setups.

## Build, Test, and Development Commands

- Use `jj` for commits, rebases, and pushes; `make help` lists task shortcuts.
- `make lint` and `make lint-hook FILE=...` run `lua-language-server` globally or per file; treat either as the pre-commit gate.
- `nvim --headless "+Lazy! sync" +qa` refreshes plugins and lockfiles, while `nvim --headless "+checkhealth" +qa` verifies toolchain dependencies.

## Revision & Branch Workflow

- After each `main` push, rebase `testing` onto it locally and push the updated `testing` bookmark so GitHub mirrors your experiments.
- Start the next `latest updates` revision from `testing`, move `main` to it with `jj`, and keep the `latest updates` description for soon-to-ship work.
- Before the next push, rebase `latest updates` onto plain `main`, move the `main` bookmark to that revision, and only then push; after the push lands, repeat by rebasing/pushing `testing` and respawning `latest updates` from it.
- After `main` is moved and pushed, immediately rebase any other local branches onto that pushed `main` revision (not the new temporary `latest updates`) so they stay aligned before you resume work on them.
- When I say “ready to push” (or similar), execute the full flow interactively: ensure the current revision has an accurate single-line `jj desc`, rebase it onto `main`, move and push `main`, rebase/push `testing`, rebase other bookmarks onto the pushed `main`, then spawn the new `latest updates` from `testing`. Halt and ask for guidance if any step hits conflicts.

## Coding Style & Naming Conventions

- Use tabs for indentation, double quotes for strings, trailing commas in tables, and keep lines ≤100 characters.
- Each plugin module returns a table named after its concern; place heavier logic in `config = function()` blocks with clear `desc` fields on mappings.
- Put shared helpers in `lua/util`, guard shell-outs with `vim.fn.executable` checks (see `kulala`), and isolate secrets or env-specific logic in `config/env.lua`.

## Testing Guidelines

- Run `make lint` or targeted `make lint-hook` before every commit; that's the minimum gate.
- Smoke test plugin specs with `nvim --headless "+lua require('lazy').stats()" +qa`.
- For LSP changes, open representative buffers headlessly (`nvim --headless +'e test.lua' +'LspInfo' +qa`) and log any regressions.

## Commit & Push Guidelines

- Keep every `jj desc` to a single-line Conventional Commit scope (e.g., `feat(lint): ...`) that reflects the full change set in the revision; add extra detail in the body only when needed.
- Create, amend, and reorder commits with `jj` so the repository’s preferred DVCS remains the source of truth before exporting to Git remotes.
- When `lazy-lock.json` changes intentionally, keep that bump in its own commit so lock diffs stay readable.
