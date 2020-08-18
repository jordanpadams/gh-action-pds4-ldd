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


### 👮‍♂️ Personal Access Token

Note that in order to make the "ping" or "empty commit" to a repository, this action must havea access to repositories. This is afforded by the `token`. To set up such a token:

1. Vist your GitHub account's Settings.
2. Go to "Developer Settings".
3. Go to "Personal access tokens".
4. Press "Generate new token"; authenticate if needed.
5. Add a note for the token, such as "PDS Ping Repo Access"
6. Check the following scopes:
    - `repo:status`
    - `repo_deployment`
    - `public_repo`
7. Press "Generate new token"

Save the token (a hex string) and install it in your source, **not target**, repository:

1. Visit the source repository's web page on GitHub.
2. Go to "Settings".
3. Go to "Secrets".
4. Press "New secret".
5. Name the secret, such as `ADMIN_GITHUB_TOKEN`, and insert the token's saved hex string as the value.
6. Press "Add secret".

Use this name in the source's workflow, such as `${{secrets.ADMIN_GITHUB_TOKEN}}`. You should now destroy any saved copies of the token's hex string.


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
