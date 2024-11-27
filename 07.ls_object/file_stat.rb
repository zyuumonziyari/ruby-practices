# frozen_string_literal: true

require 'etc'
require_relative 'file_helper'

class FileStat
  include FileHelper

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

  def initialize(options, files)
    @files = filter_hidden_files(options, files)
  end

  def output
    file_stats = @files.map { |file| [file, File::Stat.new(file)] }.to_h
    puts "total #{calculate_block_num(file_stats)}"

    max_length_nlink = calculate_max_length(file_stats, :nlink)
    max_length_size = calculate_max_length(file_stats, :size)
    file_stats.each do |file, stat|
      puts format_file_stat(stat, file, max_length_nlink, max_length_size)
    end
  end
  
  private
  
  def format_file_stat(stat, file, max_length_nlink, max_length_size)
    directory_sign = File.directory?(file) ? 'd' : '-'
    permissions = stat.mode.to_s(8)[-3..].chars.map { |digit| PERMISSIONS[digit] }.join
    nlink = stat.nlink.to_s.rjust(max_length_nlink)
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    size = stat.size.to_s.rjust(max_length_size)
    mtime = stat.mtime.strftime('%m %d %H:%M')
    filename = File.basename(file)
    "#{directory_sign}#{permissions}  #{nlink} #{owner}  #{group}  #{size} #{mtime} #{filename}"
  end

  def calculate_block_num(file_stats)
    file_stats.values.sum(&:blocks)
  end

  def calculate_max_length(file_stats, attribute)
    file_stats.values.map { |stat| stat.send(attribute).to_s.length }.max
  end
end
