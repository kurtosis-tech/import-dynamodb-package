## Import DynamoDB Package

This is a [Kurtosis Starlark Package](https://docs.kurtosis.com/quickstart) that allows you to import data from an AWS DynamoDB to a local one.

### Run

This assumes you have the [Kurtosis CLI](https://docs.kurtosis.com/cli) installed

Simply run

```bash
kurtosis run github.com/kurtosis-tech/import-dynamodb-package
```

#### Configuration

<details>
    <summary>Click to see configuration</summary>

You can configure this package using a JSON structure as an argument to the `kurtosis run` function. The full structure that this package accepts is as follows, with default values shown (note that the `//` lines are not valid JSON and should be removed!):

```javascript
{
    // Local dynamodb host and port
    "db_host": "localhost",
    "db_port": 8000,
    // AWS credentials
    "aws_access_key_id": "",
    "aws_secret_access_key": "",
    "aws_region": "us-east-1"
}
```

These arguments can either be provided manually:

```bash
kurtosis run github.com/kurtosis-tech/import-dynamodb-package '{}'
```

or by loading via a file, for instance using the [args.json](args.json) file in this repo:

```bash
kurtosis run github.com/kurtosis-tech/import-dynamodb-package --enclave import-dynamodb "$(cat args.json)"
```

</details>
