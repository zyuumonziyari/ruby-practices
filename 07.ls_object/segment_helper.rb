# frozen_string_literal: true

module SegmentHelper
    def filter_hidden_segments(options, segments)
        fileterd_segments = options.show_hidden? ? segments : segments.reject { |entry| entry.start_with?('.') }
        sort_segments(options, fileterd_segments)
      end
    
      def sort_segments(options, segments)
        options.reverse_sort? ? segments.sort.reverse : segments.sort
      end
end
