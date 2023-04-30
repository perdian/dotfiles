#!/usr/bin/env ruby

# Split an audio file into multiple MP3 files, defined in a separate file, build up like this:
#
# Example
# mp3split.rb -pattern "(?<index>\d+)\s*\.+\s*(?<title>.*)\s+(?<offset>.+)" -source source.mp3 -definitions tracks.txt

def extract_command_line_argument(argument_name, default_value: nil)
  argument_name_index = ARGV.find_index(argument_name)
  argument_value = ARGV[argument_name_index + 1] if argument_name_index && argument_name_index < (ARGV.length - 1)
  if (argument_value)
    argument_value
  elsif default_value
    default_value
  else
    raise "Cannot find argument '#{argument_name}'" if argument_name_index.nil? || argument_name_index < 0
    raise "Cannot find argument value for '#{argument_name}'"
  end
end

def quoted(value)
  output = "\""
  value.each_char do |c|
    if c =~ /[\"]/
      output << '\\"'
    else
      output << c
    end
  end
  output << "\""
  output
end

def sanitize_file_name(file_name)
  output = ""
  file_name.each_char do |c|
    if c =~ /[\w\d\.\-\_\,\'\(\)\[\]\#\!]/
      output << c
    elsif c =~ /[\s]/
      output << ' '
    elsif c =~ /[\\"]/
      output << '\''
    else
      output << '_'
    end
  end
  output
end

def parse_time_value_to_seconds(time_value)
  result_seconds = 0
  time_items = time_value.split(':')
  time_items.reverse.each_with_index do |time_item, index|
    if (index > 0)
      result_seconds = result_seconds + (time_item.to_i * (60 ** index))
    else
      result_seconds = result_seconds + time_item.to_i
    end
  end
  result_seconds
end

def create_definitions(definitions_file, definitions_pattern)
  definitions = []
  File.open(definitions_file).each_with_index do |definitions_line, index|
    if (definitions_line.strip.length > 0 && !definitions_line.start_with?("#"))
      definition_matcher = definitions_line&.strip&.match(definitions_pattern)
      raise "Cannot match line '#{definitions_line.strip}' against '#{definition_pattern}'" unless definition_matcher

      definition = {}
      definition[:title] = definition_matcher[:title].strip
      definition[:index] = definition_matcher[:index]&.to_i || index + 1
      definition[:offset_seconds] = definition_matcher[:offset_seconds].to_i if definition_matcher.names.include?("offset_seconds")
      definition[:offset_seconds] = parse_time_value_to_seconds(definition_matcher[:offset]) if definition_matcher.names.include?("offset")
      definition[:length_seconds] = definition_matcher[:length_seconds].to_i if definition_matcher.names.include?("length_seconds")
      definition[:length_seconds] = parse_time_value_to_seconds(definition_matcher[:length]) if definition_matcher.names.include?("length")
      definitions << definition

    end
  end
  definitions
end


dry_run_only = ARGV.include?('--dry-run')

source_file = extract_command_line_argument("-source")

definitions_file = extract_command_line_argument("-definitions")
definitions_pattern = Regexp.new(extract_command_line_argument("-pattern"))
definitions = create_definitions(definitions_file, definitions_pattern)

rolling_offset = 0

definitions.each_with_index do |definition, definition_index|

  start_offset_seconds = definition[:offset_seconds] || rolling_offset

  end_offset_seconds = (start_offset_seconds + definition[:length_seconds]) if start_offset_seconds && definition[:length_seconds]
  end_offset_seconds = definitions[definition_index + 1][:offset_seconds] if end_offset_seconds.nil? && definition_index < (definitions.length - 1)
  rolling_offset = end_offset_seconds

  target_filename = ""
  target_filename << (definition_index + 1).to_s.rjust(definitions.length.to_s.length, "0") << " "
  target_filename << definition[:title] << ".mp3"

  ffmpeg_string = "ffmpeg"
  ffmpeg_string << " -i \"#{source_file}\""
  ffmpeg_string << " -ab 160k"
  ffmpeg_string << " -metadata title=#{quoted(definition[:title])}"
  ffmpeg_string << " -metadata track=\"#{definition_index + 1}/#{definitions.length}\""
  ffmpeg_string << " -ss #{start_offset_seconds}" if start_offset_seconds
  ffmpeg_string << " -to #{end_offset_seconds}" if end_offset_seconds
  ffmpeg_string << " #{quoted(sanitize_file_name(target_filename))}"

  puts ffmpeg_string
  system(ffmpeg_string) unless dry_run_only

end
