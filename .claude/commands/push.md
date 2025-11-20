---
description: Execute the full push workflow for main branch
---

Execute the complete push workflow interactively with the following steps:

1. **Verify current revision description**: Check that the current revision (@) has an accurate `jj desc`. If the description is just "latest updates" or seems incomplete, ask the user to provide a proper commit message.

2. **CRITICAL - Rebase onto main@origin FIRST**: Rebase the current revision onto `main@origin` with `jj rebase -r @ -d main@origin`. This step is MANDATORY and must not be skipped, or the push will have the wrong parent (testing instead of remote main). Since the `main` bookmark is already on @, it will move automatically with the rebase.

3. **Verify the rebase**: Run `jj log -r 'ancestors(@, 3)'` to confirm @ is now based on main@origin and that the main bookmark moved with it.

4. **Push main**: Push with `jj git push -r main`.

5. **Handle testing bookmark (conditional)**: ONLY if the `testing` bookmark exists:
   - Rebase `testing` onto the new main with `jj rebase -b testing -d main`
   - Push testing with `jj git push -b testing`

6. **Rebase other bookmarks**: Rebase any other bookmarks (excluding `testing`) onto the pushed `main@origin` revision (NOT the new @).

7. **Spawn new "latest updates"**: Create a new revision with:
   - If `testing` bookmark exists: `jj new testing -m "latest updates"`
   - If `testing` doesn't exist: `jj new main -m "latest updates"`

8. **Move main bookmark**: Move the `main` bookmark to the newly created "latest updates" revision with `jj bookmark set main -r @`.

**Important**: Halt and ask for guidance if any step encounters conflicts or errors.
