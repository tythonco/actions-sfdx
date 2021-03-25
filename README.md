# GitHub Action for CI/CD with sfdx

GitHub Action for CI/CD tasks and the general use of [sfdx](https://developer.salesforce.com/platform/dx) to automate deployments and testing of Salesforce development projects.

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
on: push
name: Testing Workflow
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: test
      uses: tythonco/actions-sfdx/cicd@master
      env:
        AUTH_FILE_KEY: ${{ secrets.AUTH_FILE_KEY }}
      with:
        args: test
```

### Automated Validation

An example workflow that triggers on each commit to an open PR and runs a validation deployment.

```
on: push
name: Validation Workflow
jobs:
  validation:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: pr-filter
      uses: actions/bin/filter@master
      with:
        args: ref refs/pulls/*
    - name: validate
      uses: tythonco/actions-sfdx/cicd@master
      env:
        AUTH_FILE_KEY: ${{ secrets.AUTH_FILE_KEY }}
      with:
        args: validate
```

### Automated Deployments

Example workflow that triggers on merging a PR into `dev` and runs a deployment to QA.

```
on: pull_request
name: QA Deployment Workflow
jobs:
  qa-deployment:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: merged-pr-filter
      uses: actions/bin/filter@master
      with:
        args: merged true
    - name: dev-branch-filter
      uses: hashicorp/terraform-github-actions/base-branch-filter@master
      with:
        args: ^dev$
    - name: qa-deploy
      uses: tythonco/actions-sfdx/cicd@master
      env:
        AUTH_FILE_KEY: ${{ secrets.AUTH_FILE_KEY }}
      with:
        args: deploy sfdx_qa_auth_url.txt.enc NoTestRun
```

Example workflow that triggers on merging a PR into `master` and runs a deployment to Prod.

```
on: pull_request
name: Prod Deployment Workflow
jobs:
  prod-deployment:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: merged-pr-filter
      uses: actions/bin/filter@master
      with:
        args: merged true
    - name: master-branch-filter
      uses: hashicorp/terraform-github-actions/base-branch-filter@master
      with:
        args: ^master$
    - name: prod-deploy
      uses: tythonco/actions-sfdx/cicd@master
      env:
        AUTH_FILE_KEY: ${{ secrets.AUTH_FILE_KEY }}
      with:
        args: deploy sfdx_prod_auth_url.txt.enc
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE.md).