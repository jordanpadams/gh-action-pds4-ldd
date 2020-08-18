# PDS LDD Generation

This is an [action for GitHub](https://github.com/features/actions) that generates a PDS4 Local
Data Dictionary from an input IngestLDD, and validates the output against regression test suite (if it exists).

See the [PDS Data Dictionaries repo](https://pds-data-dictionaries.github.io/) for more details.


## ℹ️ Using this Action

To use this action in your own workflow, just provide it `with` the following parameters:

  datapath - Absolute path to where the PDS4 IngestLDD should be deployed (required: true)
  pds4_im_version: PDS4 Information Model Version. Defaults to the latest version. Use the semantic version, e.g. 1.14.0.0 (default: 'latest')
  schemas: Path(s) to schemas to use for validation. By default, validate will use the schemas specified in the PDS4 labels.
  schematrons: Path(s) to schematrons to use for validation. By default, validate will use the schemas specified in the PDS4 labels.
    required: false
  github_token: Github secret token



## 💁‍♀️ Demonstration

The following is a brief example how a workflow that shows how this action can be used:

```yaml
name: 👩‍🏫 Stable Genius Release
on:
  push:
    branches:
      - master
jobs:
  build:
    name: 👷‍♀️ Build Job
    runs-on: ubuntu-latest
    steps:
      - name: 💳 Check out the code
        uses: actions/checkout@v2
      - name: 🔧 Do something with it
        uses: …
      - name: 📡 Ping the PDS Engineering Corral
        uses: NASA-PDS/git-ping@master
        with:
          repository: nasa-pds/pdsen-corral
          token: ${{secrets.ADMIN_GITHUB_TOKEN}}
          branch: master
          message: Stable Genius service upgraded to ${{github.ref}}
```
