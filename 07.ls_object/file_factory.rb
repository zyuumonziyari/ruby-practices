# frozen_string_literal: true

require_relative 'file_segment'
require_relative 'file_stat'

class FileFactory
  def self.create(options, files)
    options.show_long_format? ? FileStat.new(options, files) : FileSegment.new(options, files)
  end
end
