# GitHub Action for the sfdx cli

The GitHub Action for [sfdx](https://docker.com/) wraps the sfdx cli to enable sfdx commands to be run.

## Usage

```
action "Test" {
  uses = "tythonco/actions-sfdx/cli@master"
  args = "force:apex:test:run -c -r human"
}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE.md).