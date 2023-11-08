#!/usr/bin/env ruby
require 'date'
require 'optparse'
def print_calendar
  params = {}
  opt = OptionParser.new
  opt.on('-m MONTH') {|v| params[:m] = v }
  opt.on('-y [YEAR]') {|v| params[:y] = v }
  opt.parse!(ARGV)
  requested_month = params[:m].to_i
  requested_year = params[:y].to_i 

  errors = []
  errors << "#{requested_month} is  not a valid month number (1..12)" if params[:m] && (requested_month > 12 || requested_month < 1)
  errors << "specify the month using '-m'" if params[:m].nil? && params[:y]
  errors << "#{requested_year} is not a valid year number (1..9999)" if params[:y] && (requested_year > 9999 || requested_year < 1)
    if errors.length.positive?
      puts errors
      exit(1)
    end
  requested_year = Date.today.year if params[:y].nil?
    if params[:y].nil? && params[:m].nil?
      requested_month = Date.today.month
      requested_year = Date.today.year
    end

  first_day = Date.new(requested_year, requested_month, 1)
  last_day = Date.new(requested_year, requested_month, -1)
  starting_day = first_day.wday 
  end_of_month = last_day.day
  thisday = Date.today.day
  this_month = Date.today.month.to_i
  this_year = Date.today.year.to_i

    puts "      #{requested_month}月 #{requested_year}"  
    puts "日 月 火 水 木 金 土"
    print "   " * starting_day
    (first_day.day..end_of_month).each do |day|
      if requested_month == this_month && requested_year == this_year && day == thisday
        print "\e[7m#{day.to_s.rjust(2)}\e[0m "
      else print day.to_s.rjust(2) + " "
      end
      if (day + starting_day) % 7 == 0
        puts
      end
    end
    puts
end
print_calendar
  