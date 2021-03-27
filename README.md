# GitHub Action for CI/CD with sfdx

GitHub Action for CI/CD tasks and the general use of [sfdx](https://developer.salesforce.com/platform/dx) to automate deployments and testing of Salesforce development projects.

## Usage

The `deploy`, `test-scratch`, and `validate` commands all assume [authentication via SFDX Auth Url](http://www.crmscience.com/single-post/2018/01/22/Salesforce-Logins-for-Continuous-Integration-and-Delivery).
Your repository should contain an *encrypted* auth url file for your DevHub org as well as any other org you'll run deployments against such as QA & Production.
These encrypted files will be decrypted using the `AUTH_FILE_KEY` secret set using either the visual workflow editor or via your repository settings.

All prebuilt commands (`deploy`, `test-scratch`, & `validate`) accept the following argument(s):

| Argument | Decription | Default |
| --- | --- | --- |
| auth_file_key | The decryption key for the auth url file | `None` |
| command | The command to execute; prebuilt options are `deploy`, `test-scratch`, & `validate` but generic shell commands are also accepted | `validate` |
| enc_auth_file | The *encrypted* auth url file used by sfdx for org authentication | `sfdx_auth_url.txt.enc` |
| source_path | Comma-separated list of paths to deploy to or validate against target org | `force-app` |

The `deploy` command accepts the following additional argument(s):

| Argument | Decription | Default |
| --- | --- | --- |
| run_tests | Lists the Apex classes containing the deployment tests to run; used when test-level is set to `RunSpecifiedTests` | `None` |
| test_level | Specifies which level of deployment tests to run; valid values are `NoTestRun`, `RunSpecifiedTests`, `RunLocalTests`, & `RunAllTestsInOrg` | `NoTestRun` |

The `test-scratch` command accepts the following additional argument(s):

| Argument | Decription | Default |
| --- | --- | --- |
| scratch_org_def_file | The json file used by sfdx for setting a scratch org's definition | `config/project-scratch-def.json` |

The `validate` command does not accept any additional arguments.

## Examples

### Automated Deployments

Example workflow that triggers either manually or on each commit made to the `dev` branch and runs a deployment to QA.

```
name: QA Deployment Workflow
on:
  push:
    branches:
      - dev
  workflow_dispatch:
jobs:
  qa-deployment:
    name: QA Deployment
    runs-on: ubuntu-latest
    steps:
    - name: Check out repository
      uses: actions/checkout@v2
    - name: Deploy to QA
      uses: tythonco/actions-sfdx@master
      with:
        auth_file_key: ${{ secrets.AUTH_FILE_KEY }}
        command: deploy
        enc_auth_file: qa_auth_url.txt.enc
```

Example workflow that triggers either manually or on each commit made to the `master` branch and runs a deployment to Production.

```
name: Production Deployment Workflow
on:
  push:
    branches:
      - master
  workflow_dispatch:
jobs:
  prod-deployment:
    name: Production Deployment
    runs-on: ubuntu-latest
    steps:
    - name: Check out repository
      uses: actions/checkout@v2
    - name: Deploy to Production
      uses: tythonco/actions-sfdx@master
      with:
        auth_file_key: ${{ secrets.AUTH_FILE_KEY }}
        command: deploy
        enc_auth_file: prod_auth_url.txt.enc
        test_level: RunLocalTests
```

### Automated Testing

An example workflow that triggers either manually or on each commit and pushes source to a new scratch org, executes tests, and finally deletes the scratch org.

```
name: Testing Workflow
on:
  push:
  workflow_dispatch:
jobs:
  test:
    name: Testing
    runs-on: ubuntu-latest
    steps:
    - name: Check out repository
      uses: actions/checkout@v2
    - name: Test on Scratch Org
      uses: tythonco/actions-sfdx@master
      with:
        auth_file_key: ${{ secrets.AUTH_FILE_KEY }}
        command: test-scratch
```

### Automated Validation

An example workflow that triggers either manually or on each commit to an open PR with `dev` as the base branch and runs a *check-only* validation deployment to Production.

```
name: Validation Workflow
on:
  pull_request:
    branches:
      - dev
  workflow_dispatch:
jobs:
  validation:
    name: Validation
    runs-on: ubuntu-latest
    steps:
    - name: Check out repository
      uses: actions/checkout@v2
    - name: Validate via check-only deployment
      uses: tythonco/actions-sfdx@master
      with:
        auth_file_key: ${{ secrets.AUTH_FILE_KEY }}
        command: validate
        enc_auth_file: prod_auth_url.txt.enc
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE.md).