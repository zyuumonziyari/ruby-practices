# frozen_string_literal: true

class Segment
    def initialize(files)
      @files = files.sort
    end
    
    def read    
    end
    
    def output
      files = @files.reject { |entry| entry.start_with?('.') }
      Format.new.output(files)
    end
  end
