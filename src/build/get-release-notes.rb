# Copyright © 2011-2012, Esko Luontola <www.orfjackal.net>
# This software is released under the Apache License 2.0.
# The license text is at http://www.apache.org/licenses/LICENSE-2.0

unless ARGV.length == 1
  puts "Usage: #{$0} RELEASE_NOTES_FILE"
  exit 1
end
release_notes_file = ARGV.shift
project_name = ENV['PROJECT_NAME'] or raise "PROJECT_NAME not set"

all_releases = IO.read(release_notes_file)
next_release = /^### Upcoming Changes$(.+?)^### #{project_name}/m.match(all_releases)
unless next_release
  raise "release notes for the upcoming release not found in: #{all_releases}"
end
puts next_release[1].strip
