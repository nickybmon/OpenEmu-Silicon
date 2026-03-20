## What does this PR do?

<!-- One sentence summary of the change -->

## Root cause / motivation

<!-- What was broken or missing, and why? -->

## What was changed

<!-- Describe the specific changes made. Be precise — reviewers will read this alongside the diff. -->

## How to verify

<!-- Step-by-step instructions to confirm the fix works -->

1. 
2. 
3. 

## Linked issues

<!-- Use "Fixes #N" to auto-close an issue on merge, or "Related to #N" to soft-link -->

Fixes #

---

## PR checklist

- [ ] Branched from an up-to-date `master` (ran `git fetch upstream && git merge upstream/master`)
- [ ] Build passes: `xcodebuild -workspace OpenEmu-metal.xcworkspace -scheme OpenEmu -configuration Debug -destination 'platform=macOS,arch=arm64' build`
- [ ] No new build logs, binaries, or credentials committed
- [ ] Copyright headers preserved on all modified files
- [ ] New files (if any) include the BSD 2-Clause header

## Label guidance

<!-- Apply the most relevant label when opening this PR. Labels are set by the repo maintainer but suggest one in a comment if needed. -->

| Your change | Suggested label |
|-------------|----------------|
| Bug fix | `bug` |
| New feature or improvement | `enhancement` |
| Docs only | `documentation` |
| Good entry-level fix | `good first issue` |
| Needs discussion | `question` |

## Author

**GitHub:** @chris-p-bacon-sudo

<!-- Milestones and projects: check https://github.com/bazley82/OpenEmuARM64/milestones and
     https://github.com/bazley82/OpenEmuARM64/projects before submitting — attach if any exist. -->
