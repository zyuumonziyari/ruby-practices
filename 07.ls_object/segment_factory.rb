# frozen_string_literal: true

class SegmentFactory

  require 'debug'
  require_relative 'option'
  require_relative 'segment'
  require_relative 'detail_segment'

  def self.create(option, files)
    if option.show_long_format?
      DetailSegment.new(option, files)
    else
      Segment.new(option, files)
    end
  end
end

option = Option.new
files = Dir.entries(Dir.pwd)
SegmentFactory.create(option, files).output
#機能ごとにクラスを分けて、それぞれoutputメソッドで出力させると、オプション指定時に、それぞれoutputされてしまう。

#引数なしの場合、規定のフォーマットで出力
#引数aの場合、隠しファイルを含めて、規定のフォーマットで出力
#rの場合、規定のフォーマットで逆順に出力
#lの場合、詳細情報を上から出力
#arの場合、隠しファイルを含めて、規定のフォーマットで逆順に出力
#al、隠しファイルを含めて、詳細情報を上から出力
#rl, ファイルを逆順にして、詳細情報を上から出力

#使い手からして、オブジェクトの生成に、if文つけるの面倒。
#以下の様なクラス設計の方がいいかな
#オブジェクトの生成(使い手)→ オプションの指定を判別(内部)⇨それぞれのオプションに合わせて出力(内部)
