# Kubetail Helm Charts

## Overview

Helm chart repository for [Kubetail](https://github.com/kubetail-org/kubetail), a general-purpose logging dashboard for Kubernetes. Published via GitHub Pages using [chart-releaser](https://github.com/helm/chart-releaser).

## Project Structure

```
charts/kubetail/            — Main Helm chart
  Chart.yaml                — Chart metadata and version
  values.yaml               — Default values
  templates/                — Kubernetes manifest templates
    _helpers.tpl             — Template helpers
    cli/                     — CLI component templates
    dashboard/               — Dashboard component templates
    cluster-api/             — Cluster API component templates
    cluster-agent/           — Cluster Agent component templates
hack/                       — Dev/test utilities
  ctlptl/                   — ctlptl cluster config
  kubetail-values-*.yaml    — Test values files
cr.yaml                     — chart-releaser config
Makefile                    — Lint targets
```

## Linting

```sh
make lint
```

This runs `helm lint` with several value combinations (default values, allowed namespaces, global labels, disabled components).

## Testing

To test chart rendering locally:

```sh
# Render templates with default values
helm template kubetail charts/kubetail

# Render with custom values
helm template kubetail charts/kubetail -f hack/kubetail-values-clusterauth.yaml
```

## Commits

Keep commits minimal and focused. Multiple commits to accomplish a task are fine if they represent logical, well-separated steps that make the change easier to review.

Use [conventional commit](https://www.conventionalcommits.org/) format: `<type>(<scope>): <description>`. Types: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`. Description in imperative mood, lowercase, no period, under 72 chars. Add body only if the "why" isn't obvious. Always sign-off on commits (`-s`). Only add a "Co-authored-by" trailer if a human was not in the loop or if the user requested it.

## Pull Requests

PR titles should be capitalized, imperative mood, no conventional commit prefixes (e.g. "Add imagePullSecrets support" not "feat: add imagePullSecrets support"). Always use the repo's `.github/pull_request_template.md` — fill in each section from the commits/diff, replace HTML comment placeholders with actual content. Use prose in summaries. Reference related issues (e.g. "Fixes #123"). Keep changes minimal and focused for quick review.
