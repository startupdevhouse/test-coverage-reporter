# How to build & run
  ```
  crystal src/app.cr
  ```

# How to compile release build
  ```
  docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:0.32.1-alpine crystal build src/app.cr --static
  ```

# Required envs
- `TEST_COVERAGE_REPORTER_TOKEN` - authentication token for ERP endpoints
