# GitHub Action for CI/CD with sfdx

The GitHub Action for CI/CD with [sfdx](https://developer.salesforce.com/platform/dx) uses sfdx to automate deployments and testing of Salesforce development projects.

## Usage

The test, validate, and deploy commands all assume [authentication via SFDX Auth Url](http://www.crmscience.com/single-post/2018/01/22/Salesforce-Logins-for-Continuous-Integration-and-Delivery). Your repository should contain an *encrypted* auth url file for your DevHub org as well as any other org you'll run deployments against such as QA & Production. These encrypted files will be decrypted using the AUTH_FILE_KEY secret set using either the visual workflow editor or in your repository settings.

The `test` command accepts the following argument(s) (in order):

| Argument | Decription | Default |
| --- | --- | --- |
| auth_url_enc_file | The *encrypted* auth url file used by sfdx for org authentication | `sfdx_auth_url.txt.enc` |
| scratch_org_def_file | The json file used by sfdx for setting a scratch org's definition | `config/project-scratch-def.json` |

The `validate` command accepts the following argument(s) (in order):

| Argument | Decription | Default |
| --- | --- | --- |
| auth_url_enc_file | The *encrypted* auth url file used by sfdx for org authentication | `sfdx_auth_url.txt.enc` |

The `deploy` command accepts the following argument(s) (in order):

| Argument | Decription | Default |
| --- | --- | --- |
| auth_url_enc_file | The *encrypted* auth url file used by sfdx for org authentication | `sfdx_auth_url.txt.enc` |
| test_level | Specifies which level of deployment tests to run; valid values are `NoTestRun`, `RunLocalTests`, & `RunAllTestsInOrg` | `RunLocalTests` |

## Examples

### Automated Testing

An example workflow that triggers on each commit and pushes source to a new scratch org, executes tests, and finally deletes the scratch org.

```
workflow "Testing Workflow" {
  on = "push"
  resolves = "test"
}

action "test" {
  uses = "tythonco/actions-sfdx/cicd@master"
  args = "test"
  secrets = ["AUTH_FILE_KEY"]
}
```

### Automated Validation

An example workflow that triggers on each commit to an open PR and runs a validation deployment.

```
workflow "Validation Workflow" {
  on = "push"
  resolves = "validate"
}

action "pr-filter" {
  uses = "actions/bin/filter@master"
  args = "ref refs/pulls/*"
}

action "validate" {
  needs = "pr-filter"
  uses = "tythonco/actions-sfdx/cicd@master"
  args = "validate"
  secrets = ["AUTH_FILE_KEY"]
}
```

### Automated Deployments

Example workflows that trigger on merging a PR into dev/master and run a deployment to QA/Production.

```
workflow "QA Deployment Workflow" {
  on = "pull_request"
  resolves = "qa deploy"
}

workflow "Prod Deployment Workflow" {
  on = "pull_request"
  resolves = "prod deploy"
}

action "merged-pr-filter" {
  uses = "actions/bin/filter@master"
  args = "merged true"
}

action "dev-branch-filter" {
  needs = "merged-pr-filter"
  uses = "hashicorp/terraform-github-actions/base-branch-filter@master"
  args = "^dev$"
}

action "master-branch-filter" {
  needs = "merged-pr-filter"
  uses = "hashicorp/terraform-github-actions/base-branch-filter@master"
  args = "^master$"
}

action "qa deploy" {
  needs = "dev-branch-filter"
  uses = "tythonco/actions-sfdx/cicd@master"
  args = "deploy sfdx_qa_auth_url.txt.enc NoTestRun"
  secrets = ["AUTH_FILE_KEY"]
}

action "prod deploy" {
  needs = "master-branch-filter"
  uses = "tythonco/actions-sfdx/cicd@master"
  args = "deploy sfdx_prod_auth_url.txt.enc"
  secrets = ["AUTH_FILE_KEY"]
}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE.md).