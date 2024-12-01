# frozen_string_literal: true

module LsCommandHelper
  private

  def filter_hidden_files(options, files)
    fileterd_files = options.show_hidden? ? files : files.reject { |entry| entry.start_with?('.') }
    sort_files(options, fileterd_files)
  end

  def sort_files(options, files)
    options.reverse_sort? ? files.sort.reverse : files.sort
  end
end
