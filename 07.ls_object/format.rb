# frozen_string_literal: true

class Format
#インスタンス変数がないなら、クラスにする必要はない
#lオプションの出力のフォーマットを指定する必要はあるか？上から順に並べるだけ。
  COLUMNS = 3

  #def initialize
  #end

  def output(files)
    max_rows = (files.count / COLUMNS.to_f).ceil
    max_column_widths = (0...COLUMNS).map do |col|
      column_values = (0...max_rows).map { |row| files[row + col * max_rows] }
      column_values.compact.map(&:length).max || 0
    end
    max_rows.times do |row|
      row_values = (0...COLUMNS).map { |col| files[row + col * max_rows] }
      formatted_row = row_values.map.with_index { |value, col| value.nil? ? '' : value.ljust(max_column_widths[col]) }
      puts formatted_row.join(' ' * COLUMNS)
    end
  end
end
