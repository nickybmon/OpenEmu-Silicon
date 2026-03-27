Run the full git shipping loop for the current branch.

1. Confirm the branch name matches the work being done. If not, stop and ask.
2. Run the build check. If it fails, stop and report — do not push a broken build.
3. Confirm the commit message uses the correct format: `<type>: <description>` with `Fixes #N` in the body if resolving an issue.
4. Push the branch and open a PR in the same step:
   gh pr create --repo chris-p-bacon-sudo/OpenEmu-Silicon --base main --title "<type>: description" --body "..."
5. If the work item is on the project board, update its status to In Progress or Done as appropriate.
6. Report: branch pushed, PR URL, board status updated (or not applicable).
