# How it works
The reporter is looking for gcov file report and sends the value to the SDH's ERP application.

Predefined paths:
- `coverage/.last_run.json`

# How to build & run
  ```
  crystal src/app.cr
  ```

# How to compile release build
  ```
  docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:latest-alpine crystal build src/app.cr --release -o test-coverage-reporter --static --no-debug
  ```

# Required envs
- `TEST_COVERAGE_REPORTER_TOKEN` - authentication token for ERP endpoints

# How to apply reporter in GithubAction
All you need to do is add a reporter after your test step in the Github Action configuration yml and set `TEST_COVERAGE_REPORTER_TOKEN` in the repository secrets.
```
- name: Save test coverage
  env:
    TEST_COVERAGE_REPORTER_TOKEN: ${{ secrets.TEST_COVERAGE_REPORTER_TOKEN }}
  run: |
    curl -s https://api.github.com/repos/startupdevhouse/test-coverage-reporter/releases/latest \
    | grep "https://github.com/startupdevhouse/test-coverage-reporter/releases/download/" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    chmod +x ./test-coverage-reporter
    ./test-coverage-reporter "$TEST_COVERAGE_REPORTER_TOKEN"
```
