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
name: Continuous Integration and Deployment

on:
   push:
     branches:
       - '*'
     paths:
       - 'src/*.xml'
       - '.github/workflows/*.yml'

env:
  IM_VERSION: '1.14.0.0'
  IM_VERSION_SHORT: '1E00'
  PDS_SCHEMA_URL: 'https://pds.nasa.gov/pds4/pds/v1/'
  REGRESSION_TEST_DIR: ${{ format('{0}/{1}/', github.workspace, 'test') }}
  # TODO - Have to hard-code this for now since Actions don't yet allow the use of env here.
  DEPLOY_DIR: ${{ format('{0}/{1}/{2}/{3}', github.workspace, 'build/development', github.sha, '1.14.0.0') }}
  # DEPLOY_DIR: ${{ format('{0}/{1}/', 'build/development', '8aab5f03e121d6be648377efc943edb0e71d49d4') }}

jobs:
  build:
    # TODO - Have to hard-code this for now since Actions don't yet allow the use of env here.
    name: 'LDD Build - v1.14.0.0'
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Generate LDDs and Validate
        uses: NASA-PDS/gh-action-pds4-ldd@master
        with:
          datapath: ${{ env.DEPLOY_DIR }}
          pds4_im_version: ${{ env.IM_VERSION }}
          pds4_im_short_version: ${{ env.IM_SHORT_VERSION }}
          schemas: ${{ format('{0}/{1}', env.DEPLOY_DIR, '*.xsd') }}
          schematrons: ${{ format('{0}/{1}', env.DEPLOY_DIR, '*.sch') }}
          pds_schema_url: ${{ env.PDS_SCHEMA_URL }}
          test_dir: ${{ env.REGRESSION_TEST_DIR }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```
