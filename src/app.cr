#!/usr/bin/crystal

require "json"
require "http/client"

unless File.exists?("./coverage/.last_run.json")
  puts "\"./coverage/.last_run.json\" not found, exiting."
  exit
end

file = File.read("./coverage/.last_run.json")
test_coverage = JSON.parse(file).dig("result", "line")

unless test_coverage
  puts "Test coverage value not found, exiting."
  exit
end

hosts = [
  "https://backend.erp-staging.startuphouse.dev/api/webhooks/EiKem3u2mqNUe5m7ouR1S5A4/github/test_coverage_reporter",
  "https://backend.erp-beta.startuphouse.dev/api/webhooks/D4SP1BsTpm9XRtM7rE7UB7FE/github/test_coverage_reporter",
  "https://backend.erp-production.startuphouse.dev/api/webhooks/D4SP1BsTpm9XRtM7rE7UB7FE/github/test_coverage_reporter",
]

channel = Channel(Nil).new

hosts.each do |host|
  spawn do
    HTTP::Client.post(
      host,
      headers: HTTP::Headers{"X-HTTP-AUTHORIZATION" => ENV["TEST_COVERAGE_REPORTER_TOKEN"], "Content-Type" => "application/json"},
      body: { "repository_name" => ENV["GITHUB_REPOSITORY"], "coverage_percent" => test_coverage }.to_json
    )
    channel.send(nil)
  rescue ex : Socket::Addrinfo::Error | KeyError
    puts ex.message
    channel.send(nil)
  end
end

puts "Sending test coverage report to the ERP..."

channel.receive
