---
description: Execute the full push workflow for main branch
---

Execute the complete push workflow interactively with the following steps:

1. **Verify current revision description**: Check that the current revision (@) has an accurate `jj desc`. If the description is just "latest updates" or seems incomplete, analyze the diff with `jj diff -r @` and generate a proper conventional commit message that accurately describes ALL changes in the revision.

2. **CRITICAL - Rebase onto main@origin FIRST**: Rebase the current revision onto `main@origin` with `jj rebase -r @ -d main@origin`. This step is MANDATORY and must not be skipped, or the push will have the wrong parent (testing instead of remote main). Since the `main` bookmark is already on @, it will move automatically with the rebase.

3. **Verify the rebase**: Run `jj log -r 'ancestors(@, 3)'` to confirm @ is now based on main@origin and that the main bookmark moved with it.

4. **Push main**: Push with `jj git push -r main`.

5. **Handle testing bookmark (conditional)**: Check if `testing` bookmark exists with `jj bookmark list`. ONLY if the `testing` bookmark exists:
   - Rebase `testing` onto the new main with `jj rebase -b testing -d main`
   - Push testing with `jj git push -b testing`

6. **Rebase other bookmarks**: Check for any other bookmarks (excluding `testing` and `main`) with `jj bookmark list`. If any exist, rebase them onto the pushed `main@origin` revision (NOT the new @).

7. **Spawn new "latest updates"**: Create a new revision with:
   - If `testing` bookmark exists: `jj new testing -m "latest updates"`
   - If `testing` doesn't exist: `jj new main -m "latest updates"`

8. **Move main bookmark**: Move the `main` bookmark to the newly created "latest updates" revision with `jj bookmark set main -r @`.

9. **Report result**: Show final state with `jj log -r 'ancestors(@, 4)' --color=never` and summarize what was pushed.

**Commit message format**:
- First line: Conventional commit format: `type(scope): description`
  - type: feat, fix, refactor, docs, test, chore, style, etc.
  - scope: the area affected (nvim, treesitter, lsp, markdown, etc.)
  - description: lowercase, no period at end
  - Example: `feat(treesitter): add feature flag to disable bash parser`
- Additional lines (optional): Add blank line then additional context if valuable
- **NEVER** include "🤖 Generated with Claude Code" or "Co-Authored-By: Claude" lines

**Important**:
- Halt and ask for guidance if any step encounters conflicts or errors
- Always use `jj` commands, never `git`
- Commit descriptions must comprehensively describe ALL changes in the diff
