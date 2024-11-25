# frozen_string_literal: true

require 'etc'
require_relative 'segment_helper'

class DetailSegment
  include SegmentHelper

  BLOCKSIZE = 8192
  PERMISSIONS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(options, segments)
    @segments = filter_hidden_segments(options, segments)
  end

  def output
    puts "total #{calculate_block_num}"

    max_length_nlink = calculate_max_length(:nlink)
    max_length_size = calculate_max_length(:size)
    @segments.each do |segment|
      segment_status = File::Stat.new(segment)
      puts format_detail_segment(segment_status, segment, max_length_nlink, max_length_size)
    end
  end
  
  private
  
  def format_detail_segment(segment_status, segment, max_length_nlink, max_length_size)
    directory_sign = File.directory?(segment) ? 'd' : '-'
    permissions = segment_status.mode.to_s(8)[-3..].chars.map { |digit| PERMISSIONS[digit] }.join
    nlink = segment_status.nlink.to_s.rjust(max_length_nlink)
    owner = Etc.getpwuid(segment_status.uid).name
    group = Etc.getgrgid(segment_status.gid).name
    size = segment_status.size.to_s.rjust(max_length_size)
    mtime = segment_status.mtime.strftime('%m %d %H:%M')
    filename = File.basename(segment)
    "#{directory_sign}#{permissions}  #{nlink} #{owner}  #{group}  #{size} #{mtime} #{filename}"
  end

  def calculate_block_num
    @segments.sum do |segment|
      segment_status = File::Stat.new(segment)
      segment_status.blocks
    end
  end

  def calculate_max_length(attribute)
    @segments.map do |segment|
      segment_status = File::Stat.new(segment)
      segment_status.send(attribute).to_s.length
    end.max
  end
end
