#!/usr/bin/env ruby

def create(file, files)
  # TODO: Create worker file
end

def apply(file)
  # TODO: Apply worker file
end

file = ARGV[1]
raise "No data file specified" unless file

command = ARGV[0]
if command == 'create'
  files = ARGV.drop(2)
  files = Dir.glob('*') if files.empty?
  create(file, files)
elsif command == 'apply'
elsif command
  raise "Invalid command: #{command}"
else
  raise "No command specified (use either 'create' or 'apply')"
end

