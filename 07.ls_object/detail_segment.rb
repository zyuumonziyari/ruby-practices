# frozen_string_literal: true

class DetailSegment < Segment
  require 'etc'

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

  def output
    @title_max_length = 0
    @link_max_length = 0

    puts "total #{calculate_block_num}"

    @segments.each do |segment|
      file_status = File::Stat.new(segment)
      output_formated_info(segment, file_status)
    end
  end

  private

  def output_formated_info(segment, file_status)
    directory_sign = mark_directory_sign(segment)
    permissions = determine_permissions(file_status)
    nlink = calculate_nlink(file_status)
    owner = Etc.getpwuid(file_status.uid).name
    group = Etc.getgrgid(file_status.gid).name
    size = calculate_size(file_status)
    mtime = file_status.mtime.strftime('%m %d %H:%M')
    filename = File.basename(segment)

    puts "#{directory_sign}#{permissions}  #{nlink} #{owner}  #{group}  #{size} #{mtime} #{filename}"
  end

  def calculate_block_num
    total_block_num = 0
    @segments.each do |segment|
      file_status = read_stat(segment)
      block_num = (file_status.size / BLOCKSIZE.to_f).ceil
      total_block_num += block_num * 8
    end
    total_block_num
  end

  def mark_directory_sign(segment)
    File.directory?(segment) ? 'd' : '-'
  end

  def determine_permissions(file_status)
    file_status.mode.to_s(8)[-3..].chars.map { |digit| PERMISSIONS[digit] }.join
  end

  def calculate_nlink(file_status)
    link_length = file_status.nlink.to_s.length
    @link_max_length = [@link_max_length, link_length].max
    file_status.nlink.to_s.rjust(@link_max_length)
  end

  def calculate_size(file_status)
    title_length = file_status.size.to_s.length
    @title_max_length = [@title_max_length, title_length].max
    file_status.size.to_s.rjust(@title_max_length)
  end
end
