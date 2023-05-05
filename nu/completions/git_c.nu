def "nu-complete git branches" [] {
  let user = (^git config --get user.name | split row '@' | get 0 | str trim)
  let local = (^git branch | lines | str replace '\* ' "" | str trim)
  let remote = (^git branch -r | lines | where { $in | str contains $user } | str replace 'remotes/[^/]+/' "" | str trim) 
  $local | append $remote
}

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

def "nu-complete git log" [] {
  ^git log --pretty=%h | lines | each { |line| $line | str trim }
}

# Check out git branches and files
export extern "git checkout" [
  ...targets: string@"nu-complete git branches"   # name of the branch or files to checkout
  --conflict: string                              # conflict style (merge or diff3)
  --detach(-d)                                    # detach HEAD at named commit
  --force(-f)                                     # force checkout (throw away local modifications)
  --guess                                         # second guess 'git checkout <no-such-branch>' (default)
  --ignore-other-worktrees                        # do not check if another worktree is holding the given ref
  --ignore-skip-worktree-bits                     # do not limit pathspecs to sparse entries only
  --merge(-m)                                     # perform a 3-way merge with the new branch
  --orphan: string                                # new unparented branch
  --ours(-2)                                      # checkout our version for unmerged files
  --overlay                                       # use overlay mode (default)
  --overwrite-ignore                              # update ignored files (default)
  --patch(-p)                                     # select hunks interactively
  --pathspec-from-file: string                    # read pathspec from file
  --progress                                      # force progress reporting
  --quiet(-q)                                     # suppress progress reporting
  --recurse-submodules: string                    # control recursive updating of submodules
  --theirs(-3)                                    # checkout their version for unmerged files
  --track(-t)                                     # set upstream info for new branch
  -b: string                                      # create and checkout a new branch
  -B: string                                      # create/reset and checkout a branch
  -l                                              # create reflog for new branch
]

# Download objects and refs from another repository
export extern "git fetch" [
  repository?: string@"nu-complete git remotes" # name of the branch to fetch
  --all                                         # Fetch all remotes
  --append(-a)                                  # Append ref names and object names to .git/FETCH_HEAD
  --atomic                                      # Use an atomic transaction to update local refs.
  --depth: int                                  # Limit fetching to n commits from the tip
  --deepen: int                                 # Limit fetching to n commits from the current shallow boundary
  --shallow-since: string                       # Deepen or shorten the history by date
  --shallow-exclude: string                     # Deepen or shorten the history by branch/tag
  --unshallow                                   # Fetch all available history
  --update-shallow                              # Update .git/shallow to accept new refs
  --negotiation-tip: string                     # Specify which commit/glob to report while fetching
  --negotiate-only                              # Do not fetch, only print common ancestors
  --dry-run                                     # Show what would be done
  --write-fetch-head                            # Write fetched refs in FETCH_HEAD (default)
  --no-write-fetch-head                         # Do not write FETCH_HEAD
  --force(-f)                                   # Always update the local branch
  --keep(-k)                                    # Keep dowloaded pack
  --multiple                                    # Allow several arguments to be specified
  --auto-maintenance                            # Run 'git maintenance run --auto' at the end (default)
  --no-auto-maintenance                         # Don't run 'git maintenance' at the end
  --auto-gc                                     # Run 'git maintenance run --auto' at the end (default)
  --no-auto-gc                                  # Don't run 'git maintenance' at the end
  --write-commit-graph                          # Write a commit-graph after fetching
  --no-write-commit-graph                       # Don't write a commit-graph after fetching
  --prefetch                                    # Place all refs into the refs/prefetch/ namespace
  --prune(-p)                                   # Remove obsolete remote-tracking references
  --prune-tags(-P)                              # Remove any local tags that do not exist on the remote
  --no-tags(-n)                                 # Disable automatic tag following
  --refmap: string                              # Use this refspec to map the refs to remote-tracking branches
  --tags(-t)                                    # Fetch all tags
  --recurse-submodules: string                  # Fetch new commits of populated submodules (yes/on-demand/no)
  --jobs(-j): int                               # Number of parallel children
  --no-recurse-submodules                       # Disable recursive fetching of submodules
  --set-upstream                                # Add upstream (tracking) reference
  --submodule-prefix: string                    # Prepend to paths printed in informative messages
  --upload-pack: string                         # Non-default path for remote command
  --quiet(-q)                                   # Silence internally used git commands
  --verbose(-v)                                 # Be verbose
  --progress                                    # Report progress on stderr
  --server-option(-o): string                   # Pass options for the server to handle
  --show-forced-updates                         # Check if a branch is force-updated
  --no-show-forced-updates                      # Don't check if a branch is force-updated
  -4                                            # Use IPv4 addresses, ignore IPv6 addresses
  -6                                            # Use IPv6 addresses, ignore IPv4 addresses
]

# Push changes
export extern "git push" [
  remote?: string@"nu-complete git remotes",      # the name of the remote
  ...refs: string@"nu-complete git branches"      # the branch / refspec
  --all                                           # push all refs
  --atomic                                        # request atomic transaction on remote side
  --delete(-d)                                    # delete refs
  --dry-run(-n)                                   # dry run
  --exec: string                                  # receive pack program
  --follow-tags                                   # push missing but relevant tags
  # TODO: force-with-lease has an optional string param but nushell does not currently impl optional string params
  --force-with-lease                              # require old value of ref to be at this value
  --force(-f)                                     # force updates
  --ipv4(-4)                                      # use IPv4 addresses only
  --ipv6(-6)                                      # use IPv6 addresses only
  --mirror                                        # mirror all refs
  --no-verify                                     # bypass pre-push hook
  --porcelain                                     # machine-readable output
  --progress                                      # force progress reporting
  --prune                                         # prune locally removed refs
  --push-option(-o): string                       # option to transmit
  --quiet(-q)                                     # be more quiet
  --receive-pack: string                          # receive pack program
  --recurse-submodules: string                    # control recursive pushing of submodules
  --repo: string                                  # repository
  --set-upstream(-u)                              # set upstream for git pull/status
  --signed: string                                # GPG sign the push
  --tags                                          # push tags (can't be used with --all or --mirror)
  --thin                                          # use thin pack
  --verbose(-v)                                   # be more verbose
]

# Switch between branches and commits
export extern "git switch" [
  switch?: string@"nu-complete git branches"      # name of branch to switch to
  --create(-c): string                            # create a new branch
  --detach(-d): string@"nu-complete git log"      # switch to a commit in a detatched state
  --force-create(-C): string                      # forces creation of new branch, if it exists then the existing branch will be reset to starting point
  --force(-f)                                     # alias for --discard-changes
  --guess                                         # if there is no local branch which matches then name but there is a remote one then this is checked out
  --ignore-other-worktrees                        # switch even if the ref is held by another worktree
  --merge(-m)                                     # attempts to merge changes when switching branches if there are local changes
  --no-guess                                      # do not attempt to match remote branch names
  --no-progress                                   # do not report progress
  --no-recurse-submodules                         # do not update the contents of sub-modules
  --no-track                                      # do not set "upstream" configuration
  --orphan: string                                # create a new orphaned branch
  --progress                                      # report progress status
  --quiet(-q)                                     # suppress feedback messages
  --recurse-submodules                            # update the contents of sub-modules
  --track(-t)                                     # set "upstream" configuration
]

def "nu-complete git diff" [] {
  # TODO: this impl includes untracked files which don't need to be shown
  git status --porcelain | lines | str replace '.[^s]? ' ''
}

export extern "git diff" [
  ...files: string@"nu-complete git diff"         # files to diff
  -z                                              # output diff-raw with lines terminated with NUL.
  -p                                              # output patch format.
  -u                                              # synonym for -p.
  --patch-with-raw                                # output both a patch and the diff-raw format.
  --stat                                          # show diffstat instead of patch.
  --numstat                                       # show numeric diffstat instead of patch.
  --patch-with-stat                               # output a patch and prepend its diffstat.
  --name-only                                     # show only names of changed files.
  --name-status                                   # show names and status of changed files.
  --full-index                                    # show full object name on index lines.
  --abbrev: int                                   # abbreviate object names in diff-tree header and diff-raw.
  -R                                              # swap input file pairs.
  -B                                              # detect complete rewrites.
  -M                                              # detect renames.
  -C                                              # detect copies.
  --find-copies-harder                            # try unchanged files as candidate for copy detection.
  -l: int                                         # limit rename attempts up to <n> paths.
  -O: string                                      # reorder diffs according to the <file>.
  -S: string                                      # find filepair whose only one side contains the string.
  --pickaxe-all                                   # show all files diff when -S is used and hit is found.
  -a  --text                                      # treat all files as text.
]

def "nu-complete git add" [] {
  git status --porcelain | lines | str replace '.[^s]? ' ''
}

export extern "git add" [
  ...files: string@"nu-complete git add"
  -n, --dry-run                                   # dry run
  -v, --verbose                                   # be verbose
  -i, --interactive                               # interactive picking
  -p, --patch                                     # select hunks interactively
  -e, --edit                                      # edit current diff and apply
  -f, --force                                     # allow adding otherwise ignored files
  -u, --update                                    # update tracked files
  --renormalize                                   # renormalize EOL of tracked files (implies -u)
  -N, --intent-to-add                             # record only the fact that the path will be added later
  -A, --all                                       # add changes from all tracked and untracked files
  --ignore-removal                                # ignore paths removed in the working tree (same as --no-all)
  --refresh                                       # don't add, only refresh the index
  --ignore-errors                                 # just skip files which cannot be added because of errors
  --ignore-missing                                # check if - even missing - files are ignored in dry run
  --sparse                                        # allow updating entries outside of the sparse-checkout cone
  --chmod: string                                 # override the executable bit of the listed files
  --pathspec-from-file: string                    # read pathspec from file
  --pathspec-file-nul: string                     # with --pathspec-from-file, pathspec elements are separated with NUL character
]