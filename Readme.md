# How to build & run
  ```
  crystal src/app.cr
  ```

# How to compile release build
  ```
  docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:latest-alpine crystal build src/app.cr --static -o test_coverage_reporter
  ```

# Required envs
- `TEST_COVERAGE_REPORTER_TOKEN` - authentication token for ERP endpoints
