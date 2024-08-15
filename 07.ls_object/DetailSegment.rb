# frozen_string_literal: true

class DetailSegment < Segment
    BLOCKSIZE = 8192
  
    def initialize(files)
      super
    end
      
      link_length = fs.nlink.to_s.length
      link_max_length = [link_max_length, link_length].max
      
      permissions = mode_to_permission(fs.mode)
      owner = Etc.getpwuid(fs.uid).name
      group = Etc.getgrgid(fs.gid).name
      mtime = fs.mtime.strftime('%m %d %H:%M')
      basename = File.basename(file)
      directory_sign = File.directory?(file) ? 'd' : '-'
      
    end
  end
  
  def read
  end
  
  def output(fs)
    puts calculate_block_num
    @files.each do |file|
      fs = File::Stat.new(file)
      puts "#{directory_sign}#{permissions}  #{fs.nlink.to_s.rjust(link_max_length)} #{owner}  #{group}  #{output_size(fs)} #{mtime} #{basename}"
      # puts calculate_block_num ~ mtime
    end
  
    def output_block_num
      total_block_num = 0
      @files.each do |file|
        fs = File::Stat.new(file)
        block_num = (fs.size / BLOCKSIZE.to_f).ceil
        total_block_num += block_num * 8
      end
      puts total_block_num
    end
    
    
    def permissions
    end
    
    def output_nlink
      fs.nlink.to_s.rjust(link_max_length)
    end
    
    def owner
    end
    
    def group
    end
    
    def output_size(fs)
      title_length = fs.size.to_s.length
      title_max_length = [title_max_length, title_length].max
      fs.size.to_s.rjust(title_max_length)
    end
    
    def mtime
    end
  
  end
