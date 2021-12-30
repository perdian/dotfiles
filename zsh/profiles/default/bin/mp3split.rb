#!/usr/bin/env ruby

# Split an audio file into multiple MP3 files, defined in a separate file, build up like this:
#
# (0:00:00) 01. Polijarny Inlet
# (0:00:39) 02. Hymn To Red October (Main Title)
#
# The first element is the offset from which the new file starts
# The second element is the name of the target file

source_file = File.expand_path(ARGV[0])
raise "Cannot find source file at: #{File.expand_path(ARGV[0])}" unless File.exist?(source_file)

definitions_file = File.expand_path(ARGV[1])
raise "Cannot load definitions from file: #{File.expand_path(ARGV[1])}" unless File.exist?(definitions_file)
puts "Loading target item definitions from: #{File.expand_path(ARGV[1])}"

definitions = []
File.readlines(definitions_file).each do |line|
  unless line.start_with?("#")
    line_matcher = /[\(\[]*?(\d+:\d+:\d+)[\)\]\W]*(.*)/.match(line.strip)
    if line_matcher
      target_offset_matcher = /(\d+):(\d+):(\d+)/.match(line_matcher[1])
      target_offset = target_offset_matcher
      target_offset_seconds = target_offset_matcher[3].to_i + (target_offset_matcher[2].to_i * 60) + (target_offset_matcher[1].to_i * 60 * 60)
      target_filename = line_matcher[2]
      definitions.push(offset: target_offset_seconds, title: line_matcher[2])
    end
  end
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

(0...definitions.length).each do |i|

  this_offset = definitions[i][:offset]
  this_offset_string = Time.at(this_offset).utc.strftime("%H:%M:%S")
  next_offset = definitions[i+1][:offset] if definitions[i+1]
  next_offset_string = Time.at(next_offset).utc.strftime("%H:%M:%S") if next_offset
  duration_seconds = next_offset - this_offset if next_offset
  duration_string = Time.at(duration_seconds).utc.strftime("%H:%M:%S") if duration_seconds
  original_title = definitions[i][:title]
  target_title = original_title
  target_filename = target_title
  target_title_index_matcher = /(\d+)\.\s+(.*)/.match(original_title)
  if target_title_index_matcher
    target_index = target_title_index_matcher[1].to_i
    target_title = target_title_index_matcher[2]
    target_filename = "#{target_index.to_s.rjust(2, "0")} #{target_title}"
  end

  ffmpeg_string = "ffmpeg"
  ffmpeg_string << " -i #{source_file}"
  ffmpeg_string << " -ss #{this_offset_string}"
  ffmpeg_string << " -t #{duration_string}" if duration_string
  ffmpeg_string << " -metadata title=#{quoted(target_title)}"
  ffmpeg_string << " -metadata track=\"#{target_index}/#{definitions.length}\"" if target_index
  ffmpeg_string << " -ab 160k"
  ffmpeg_string << " #{quoted(sanitize_file_name(target_filename) + '.mp3')}"
  puts "Processing: \"#{target_filename}\" from #{this_offset_string} with duration #{duration_string}"
  puts ">> #{ffmpeg_string}"

  system(ffmpeg_string)

end
