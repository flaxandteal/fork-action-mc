# MC
A GitHub action for exposing the MinIO Client to your workflow for all your cheapo S3 needs

## Usage

This example will create a S3 bucket called `testruction` at _service url_ `https://play.min.io` and set the `download` _policy_ for it.

```yml
    - name: Create a bucket
      uses: zalari/action-mc@master
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        MC_URL: https://play.min.io
        MC_ALIAS: play
      with:
        args: mb create play/testruction -p
    - name: Set anonymous download policy on bucket
      uses: zalari/action-mc@master
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        MC_URL: https://play.min.io
        MC_ALIAS: minio
      with:
        args: policy set download play/testruction
```
It is just a wrapper for the [MinIO Client](https://github.com/minio/mc).
Actual arguments are passed to the action via the `args` parameter.

#### Secrets and environment variables

The following variables may be passed to the action as secrets or environment variables. 

- `AWS_ACCESS_KEY_ID` (**required**) - The storage service access key id.
- `AWS_SECRET_ACCESS_KEY` (**required**) - The storage service secret access key.
- `MC_ALIAS` - The mc config host alias. _Defaults_ to `s3`
- `MC_URL` - The URL to the object storage service. _Defaults_ to `https://s3.amazonaws.com` for Amazon S3.
- `MC_API_SIGNATURE` - The api signature to use for creating the host config. _Defaults_ to `S3v4`, can alternatively `S3v2`.
- `MC_BUCKET_LOOKUP` - The bucket lookup to use for creating the host config. _Defaults_ to `auto`, can be `dns` or `path` as well.

## Complete workflow example

The workflow copies everything from a `dist` dir to a newly dynamically generated bucket from the branch name with anonymous download policy set. Also known as poor man's netlify.

```yml
name: Poor man's netlify static site deployment
on:
  push:
    branches:
      - master
jobs:
  publish-to-public-bucket:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Create test data
        run: mkdir dist && uptime > dist/uptime.txt
      # taken from -> https://stackoverflow.com/questions/58033366/how-to-get-current-branch-within-github-actions#comment102508135_58034787
      - name: Extract branch name
        shell: bash
        run: echo "##[set-output name=branch;]$(echo ${GITHUB_REF##*/})"
        id: extract_branch
      - name: Create a bucket from branch name
        uses: zalari/action-mc@master
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          MC_URL: https://play.min.io
          MC_ALIAS: play
        with:
          args: mb create play/testruction-${{ steps.extract_branch.outputs.branch }} -p
      - name: Set anonymous download policy on bucket
        uses: zalari/action-mc@master
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          MC_URL: https://play.min.io
          MC_ALIAS: minio
        with:
          args: policy set download play/testruction-${{ steps.extract_branch.outputs.branch }}
      - name: Upload dist to public bucket
        uses: zalari/action-mc@master
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          MC_URL: https://play.min.io
          MC_ALIAS: minio
        with:
          args: cp -r dist/ play/testruction-${{ steps.extract_branch.outputs.branch }}
```

## License

[MIT](LICENSE)
