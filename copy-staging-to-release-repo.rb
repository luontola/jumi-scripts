# Copyright © 2011-2012, Esko Luontola <www.orfjackal.net>
# This software is released under the Apache License 2.0.
# The license text is at http://www.apache.org/licenses/LICENSE-2.0

require 'json'
require 'fileutils'

def get_env_var(name)
  ENV[name] or raise "Missing environment variable: #{name}"
end

def get_file_urls(index)
  index.flat_map do |entry|
    if entry['type'] == 'folder'
      get_file_urls(entry['files'])
    else
      entry['url']
    end
  end
end

def list_go_artifacts(base_url, username, password)
  index_file = 'index.tmp'
  begin
    http_get(index_file, "#{base_url}.json", username, password)
    index_json = IO.read(index_file)
    get_file_urls(JSON.parse(index_json))
  ensure
    FileUtils.rm_f(index_file)
  end
end

def http_get(file, source_url, username, password)
  puts "GET #{source_url}"
  system('curl',
         '--fail', '--silent', '--show-error',
         '--basic', '--user', username+':'+password,
         '--output', file,
         source_url
  ) or raise "Failed to download #{source_url}"
end

def http_put(file, target_url, username, password)
  puts "PUT #{target_url}"
  system('curl',
         '--fail', '--silent', '--show-error',
         '--basic', '--user', username+':'+password,
         '--upload-file', file,
         target_url
  ) or raise "Failed to upload #{target_url}"
end

go_dependency_locator = get_env_var('GO_DEPENDENCY_LOCATOR_JUMI')

staging_repo_url = "http://omega.orfjackal.net:8153/go/files/#{go_dependency_locator}/build-release/staging"
staging_username = get_env_var('STAGING_USERNAME')
staging_password = get_env_var('STAGING_PASSWORD')

release_repo_url = "https://oss.sonatype.org/service/local/staging/deploy/maven2"
release_username = get_env_var('RELEASE_USERNAME')
release_password = get_env_var('RELEASE_PASSWORD')

source_urls = list_go_artifacts(staging_repo_url, staging_username, staging_password)

source_urls.each do |source_url|
  relative_path = source_url.sub(staging_repo_url, '').sub(/^\//, '')
  target_url = source_url.sub(staging_repo_url, release_repo_url)
  temp_file = 'artifact.tmp'
  begin
    puts "\nCopy #{relative_path}"
    http_get(temp_file, source_url, staging_username, staging_password)
    http_put(temp_file, target_url, release_username, release_password)
  ensure
    FileUtils.rm_f(temp_file)
  end
end
