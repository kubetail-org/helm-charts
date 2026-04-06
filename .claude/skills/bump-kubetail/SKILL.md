---
name: bump-kubetail
description: Bump kubetail components (dashboard, cluster-api, cluster-agent) to their latest releases and update config variables
disable-model-invocation: true
---

# Bump Kubetail Skill

Bump the kubetail components (dashboard, cluster-api, cluster-agent) to their latest releases and update config variables as needed.

## Context

The helm-charts repo manages the `kubetail` Helm chart with three main components:

| Component     | Image tag location in values.yaml | Config struct source                       |
| ------------- | --------------------------------- | ------------------------------------------ |
| dashboard     | `kubetail.dashboard.image.tag`    | `modules/dashboard/pkg/config/config.go`   |
| cluster-api   | `kubetail.clusterAPI.image.tag`   | `modules/cluster-api/pkg/config/config.go` |
| cluster-agent | `kubetail.clusterAgent.image.tag` | `crates/cluster_agent/src/config.rs`       |

The source code is available at https://github.com/kubetail-org/kubetail. Git tags follow the pattern `<component>/v<semver>` (e.g., `dashboard/v0.10.1`, `cluster-api/v0.5.3`, `cluster-agent/v0.6.2`).

Runtime config for each component is rendered via Helm ConfigMap templates:

| Component     | ConfigMap template                                        | Values path                           |
| ------------- | --------------------------------------------------------- | ------------------------------------- |
| dashboard     | `charts/kubetail/templates/dashboard/config-map.yaml`     | `kubetail.dashboard.runtimeConfig`    |
| cluster-api   | `charts/kubetail/templates/cluster-api/config-map.yaml`   | `kubetail.clusterAPI.runtimeConfig`   |
| cluster-agent | `charts/kubetail/templates/cluster-agent/config-map.yaml` | `kubetail.clusterAgent.runtimeConfig` |

## Steps

### 1. Ensure the helm-charts branch is up-to-date

First, determine which remote points to `kubetail-org/helm-charts`:

```bash
git remote -v | grep 'kubetail-org/helm-charts.*fetch'
```

Use that remote name (e.g., `origin`, `upstream`, etc.) for all subsequent commands. Call it `<remote>`.

Then run in parallel:

- `git fetch <remote>`
- Check the current branch name with `git branch --show-current`

Then check if the current branch is behind `<remote>/main`:

```bash
git log HEAD..<remote>/main --oneline
```

- If there are commits the current branch doesn't have, warn the user and stop -- they should rebase/merge before proceeding.

### 2. Determine current versions

Read `charts/kubetail/values.yaml` and extract the current image tags:

- `kubetail.dashboard.image.tag` (e.g., `"0.10.1"`)
- `kubetail.clusterAPI.image.tag` (e.g., `"0.5.3"`)
- `kubetail.clusterAgent.image.tag` (e.g., `"0.6.2"`)

### 3. Find latest versions

Use the GitHub API to list tags for each component:

```bash
gh api repos/kubetail-org/kubetail/git/matching-refs/tags/dashboard/v --jq '.[].ref' | sed 's|refs/tags/dashboard/v||' | grep -v '\-rc' | sort -V | tail -1
gh api repos/kubetail-org/kubetail/git/matching-refs/tags/cluster-api/v --jq '.[].ref' | sed 's|refs/tags/cluster-api/v||' | grep -v '\-rc' | sort -V | tail -1
gh api repos/kubetail-org/kubetail/git/matching-refs/tags/cluster-agent/v --jq '.[].ref' | sed 's|refs/tags/cluster-agent/v||' | grep -v '\-rc' | sort -V | tail -1
```

Take the highest non-rc version for each component.

### 4. Check for config changes

For each component where the version has changed, use the GitHub compare API to diff the config struct between the old and new tags:

**Dashboard (Go):**

```bash
gh api repos/kubetail-org/kubetail/compare/dashboard/v<old>...dashboard/v<new> --jq '.files[] | select(.filename == "modules/dashboard/pkg/config/config.go") | .patch'
```

**Cluster API (Go):**

```bash
gh api repos/kubetail-org/kubetail/compare/cluster-api/v<old>...cluster-api/v<new> --jq '.files[] | select(.filename == "modules/cluster-api/pkg/config/config.go") | .patch'
```

**Cluster Agent (Rust):**

```bash
gh api repos/kubetail-org/kubetail/compare/cluster-agent/v<old>...cluster-agent/v<new> --jq '.files[] | select(.filename == "crates/cluster_agent/src/config.rs") | .patch'
```

Also fetch the current config struct at the new tag and read the current Helm ConfigMap template + values to understand all available options:

```bash
gh api repos/kubetail-org/kubetail/contents/<path>?ref=<component>/v<new> --jq '.content' | base64 -d
```

### 5. Assess config changes

For each config diff:

- If the diff is empty or only contains trivial changes (comments, formatting), proceed to image tag updates.
- If there are **new config fields**: check if they map cleanly to existing `runtimeConfig` values structure. If the new fields can be added as simple key-value pairs under the existing `runtimeConfig` hierarchy, propose the additions.
- If there are **removed config fields**: propose removing them from `runtimeConfig` in values.yaml.
- If the config changes require **non-trivial template modifications** (new template logic, conditionals, structural changes to ConfigMap rendering, new Kubernetes resources, etc.): **stop and tell the user** that a manual chart update is needed. Explain what changed and why it can't be handled by a simple bump.

Collect all proposed config changes and **present them to the user for approval** before making any edits. Show a clear diff-like summary of what will change.

### 6. Apply approved changes

After the user approves (or modifies) the config proposals:

1. **Update image tags** in `charts/kubetail/values.yaml` -- replace the old tag value with the new one for each component that changed.
2. **Apply config changes** to `charts/kubetail/values.yaml` -- add/remove/modify `runtimeConfig` fields as approved.
3. **Update `charts/kubetail/Chart.yaml`** — determine the bump severity by looking at the semver change across all components:
   - If any component has a **major** version bump → bump `appVersion` and `version` major.
   - If any component has a **minor** version bump → bump `appVersion` and `version` minor.
   - If all component changes are **patch** only → bump `appVersion` and `version` patch.

   Both `version` and `appVersion` get the same bump level and stay in sync.

### 7. Report

Summarize what was changed:

- List each component: old version -> new version (or "no change")
- List any config keys added or removed
- Note the new chart `version` and `appVersion`

## Rules

- NEVER skip the user approval step for config changes.
- Only bump components where the latest tag is newer than the current version.
- If a component is already at the latest version, mention it but make no changes.
- Exclude release candidate tags (those containing `-rc`) when determining the latest version.
- If config changes require non-trivial template modifications, bail out and explain what needs to be done manually.
- Make best-effort guesses for new config values based on context (existing config patterns, field names, defaults in the source struct). Acknowledge uncertainty where it exists.
- Do NOT guess secret values -- for fields that are clearly secrets (keys, passwords, tokens), note them as `<REPLACE_ME>` and call them out to the user.
- When reading Go config structs, pay attention to `validate:"required"` tags -- these fields must have values.
- When reading Rust config structs, pay attention to `#[serde(default)]` and `Option<T>` types to determine which fields are optional.
- Run all independent git/read operations in parallel for speed.
