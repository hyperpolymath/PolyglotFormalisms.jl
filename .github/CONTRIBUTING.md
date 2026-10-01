# Contributing to PolyglotFormalisms.jl

Thank you for your interest in contributing to PolyglotFormalisms.jl!

## How to Contribute

1.  **Report Issues**: Found a bug or have a feature request? Open an
    issue on GitHub.

2.  **Submit Pull Requests**:

    - Fork the repository

    - Create a feature branch

    - Make your changes

    - Ensure all tests pass: `julia` `--project=.` `-e` `'using` `Pkg;`
      `Pkg.test()'`

    - Submit a pull request

## Guidelines

### Implementation Requirements

1.  **Match aLib Specifications**: All implementations must exactly
    match the
    [aggregate-library](https://github.com/hyperpolymath/aggregate-library)
    specifications.

2.  **Include Tests**: Every function must have conformance tests
    matching the aLib spec test cases.

3.  **Document Properties**: Document all mathematical properties
    (commutativity, associativity, etc.) in docstrings.

4.  **Formal Verification**: When Axiom.jl integration is complete,
    properties should be proven with `@prove` macros.

### Code Style

- Follow standard Julia style conventions

- Use descriptive variable names

- Include SPDX license headers

- Write clear docstrings with examples

### Testing

All tests must pass before merging:

``` bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

### Commit Messages

Use conventional commits format: - `feat:` for new features - `fix:` for
bug fixes - `docs:` for documentation changes - `test:` for test
additions/modifications

## Questions?

Open a GitHub issue or discussion for any questions about contributing.

## Signed commits

Every commit that reaches the default branch must be signed; a ruleset refuses
unsigned pushes. Estate policy:
[SIGNING-POLICY](https://github.com/hyperpolymath/standards/blob/main/docs/SIGNING-POLICY.adoc).

- **People and interactive agents** sign with an SSH key registered on GitHub
  as a *signing* key (`gpg.format=ssh`, `user.signingkey=<key>.pub`,
  `commit.gpgsign=true`). The committer email must be verified on that account.
- **Apps, bots and workflows** never `git push` local commits. They write
  through the API (`createCommitOnBranch` or the estate `signed-push` action)
  so that GitHub signs each commit.
- Merge PRs with **squash**. The ruleset checks every commit on the PR branch,
  not just the result, so one unsigned commit blocks the merge. Re-create such a
  branch with signed commits (`git cherry-pick -S`) and open a new PR.
  Rebase-merge replays commits unsigned and is disabled.
