#!/usr/bin/crystal

require "json"
require "uri"
require "http/client"

file = File.read("./coverage/.last_run.json")
test_coverage = JSON.parse(file)["result"]["line"]

repository_name = ENV["GITHUB_REPOSITORY"]
hosts = ENV["HOSTS"].split(",").map { |url| URI.parse(url) }

channel = Channel(Nil).new

def save_test_coverage(uri, repository_name, test_coverage)
  uri.path = "/api/webhooks/sdh/github/test_coverage_reporter"

  puts uri

  HTTP::Client.post(
    uri,
    headers: HTTP::Headers{"X-HTTP-AUTHORIZATION" => ENV["AUTH_TOKEN"], "Content-Type" => "application/json"},
    body: { "repository_name" => repository_name, "coverage_percent" => test_coverage }.to_json
  )
end

hosts.each do |host|
  spawn do
    save_test_coverage(host, repository_name, test_coverage)
    channel.send(nil)
  end
end

channel.receive
