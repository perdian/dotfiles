#!/usr/bin/env ruby

# 1. Create a configuration file that lists all affected files with their original name and their target name:
#
# $ renamer.rb create out
#
# The file looks like this:
#
# a § a
# b § b
# c § c
# d § d
#
# 2. Add counter variables on the right to apply the renaming:
#
# a § a_$1
# b § b_$1
# c § c_$1
# d § d_$2
#
# 3. Apply the configuration
#
# $ renamer.rb apply out
#
# 4. The files will be renamed to:
#
# a -->  a_1
# b -->  b_2
# c -->  c_3
# d -->  d_1

class Rule
  def initialize(value, counter_usages)
    @value = value
    @variables_used = []
    matches = value.scan(/\$([\d])/).each do |v|
      v.each do |v_value|
        @variables_used.push(v_value)
        counter_usages[v_value] = (counter_usages[v_value] || 0) + 1
      end
    end
  end
  def resolve(counter_values, counter_usages)
    result = @value
    @variables_used.each do |variable|
      max_characters = counter_usages[variable].to_s.length
      variable_value = (counter_values[variable] || 0) + 1
      variable_value_formatted = variable_value.to_s
      while variable_value_formatted.length < max_characters
        variable_value_formatted = "0#{variable_value_formatted}"
      end
      result = result.gsub("$#{variable}", variable_value_formatted);
      counter_values[variable] = variable_value
    end
    result
  end
  def to_s
    @value
  end
end

class Context
  def initialize
    @counter_values = {}
    @counter_usages = {}
    @rules = {}
  end
  def push(source_name, target_name)
    @rules[source_name] = Rule.new(target_name, @counter_usages)
  end
  def execute
    @rules.each do |source_name, rule|
      target_name = rule.resolve(@counter_values, @counter_usages)
      if File.exists?(source_name)
        puts "Renaming '#{source_name}' to '#{target_name}' using rule '#{rule}'"
        File.rename(source_name, target_name)
      else
        puts "ERROR: File not found at: #{source_name}"
      end
    end
  end
end

def create(file, files)
  max_file_length = 0
  files.each { |file| max_file_length = [file.length, max_file_length].max }
  out = ""
  files.sort.each do |file|
    out << file
    for i in file.length..max_file_length-1
      out << ' '
    end
    out << ' § '
    extension_index = file.rindex('.')
    if extension_index
      out << file[0, extension_index] << file[extension_index,file.length].downcase
    else
      out << file
    end
    out << "\n"
  end
  puts("Writing into file: #{file}")
  File.write(file, out)
end

def apply(file)
  puts("Reading rules from file: #{file}")
  context = Context.new
  File.open(file).each do |line|
    line_items = line.split('§')
    if line_items.length >= 2
      source_name = line_items[0].strip
      target_name = line_items[1].strip
      context.push(source_name, target_name) unless source_name == target_name
    end
  end
  context.execute
end

file = ARGV[1]
raise "No data file specified" unless file

command = ARGV[0]
if command == 'create'
  files = ARGV.drop(2)
  files = Dir.glob('*') if files.empty?
  create(file, files)
elsif command == 'apply'
  apply(file)
elsif command
  raise "Invalid command: #{command}"
else
  raise "No command specified (use either 'create' or 'apply')"
end
