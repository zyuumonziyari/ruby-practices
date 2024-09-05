# frozen_string_literal: true

require 'minitest/autorun'
require './segment'

class SegmentTest < Minitest::Test
  def setup
    @option_mock = Minitest::Mock.new
    @segments = ['file1', 'file2', '.hidden_file']
  end

  def test_filter_hidden_segments
    @option_mock.expect(:show_hidden?, false, []) # :show_hidden? は2回呼び出される
    @option_mock.expect(:show_hidden?, false, []) # :show_hidden? は2回呼び出される
    @option_mock.expect(:reverse_sort?, false, []) # reverse_sort? メソッドのモックを追加

    segment = Segment.new(@option_mock, @segments)
    assert_equal %w[file1 file2], segment.send(:filter_hidden_segments, @segments)
  end

  def test__segments
    @option_mock.expect(:show_hidden?, false, []) # :show_hidden? は2回呼び出される
    @option_mock.expect(:show_hidden?, false, []) # :show_hidden? は2回呼び出される
    @option_mock.expect(:reverse_sort?, true, []) # reverse_sort? メソッドのモックを追加
    @option_mock.expect(:reverse_sort?, true, []) # reverse_sort? メソッドのモックを追加

    segment = Segment.new(@option_mock, @segments)
    assert_equal %w[file2 file1], segment.send(:prepare_segments, @segments)
  end
end
