# vcsh-root

This is the root repository of my [vcsh-based](https://github.com/RichiH/vcsh)
versioned home directory system.  `vcsh` provides tools used to version files
in a directory, typically your homedir, via one or more overlapping git
repositories.  This makes it easy to manage, document, and publish topical
repositories (e.g. your Emacs or Vim configuration) separately.

## Branches

### `master`

The `master` branch is the base configuration for vcsh and
[mr](https://myrepos.branchable.com/).  The use of `mr` with vcsh is optional,
but this repository provides an example of the use of the two tools together.

### `bootstrap`

The `bootstrap` branch is a detached HEAD branch that provides a `bootstrap.sh`
script. When invoked on a new system, this script installs vcsh and mr,
followed by installing the repos as specified in the vcsh configuration here.

## Testing

The main testing mechanism for this repo is via the `Vagrantfile` in each of
its branches.  `Vagrantfile` on `master` builds a VM using the vcsh
configuration in the repo's working directory.  This is useful to test changes
on `master` before pushing them.  `Vagrantfile` on `bootstrap` tests the
bootstrap script using the current remote repository URLs (on GitHub at this
writing).
