#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby

require 'date'
require 'optparse'
require 'color_echo'
def print_calendar
  params = {}
  opt = OptionParser.new
  opt.on('-m MONTH') {|v| params[:m] = v }
  opt.on('-y [YEAR]') {|v| params[:y] = v }
  opt.parse!(ARGV)
  requested_month = params[:m].to_i
  requested_year = params[:y].to_i 
  case
  when params[:m] && params[:y] && (requested_month > 12 || requested_month < 1) && (requested_year > 9999 || requested_year < 1)
    puts "#{requested_month} is  not a valid month number (1..12)"
    puts "#{requested_year} is not a valid year number (1..9999)"
    return
  when params[:y] && params[:m].nil? && (requested_year > 9999 || requested_year < 1)
    puts "#{requested_year} is not a valid year number (1..9999)"
    return
  when params[:y].nil? && requested_month >= 1 && requested_month <= 12 
    requested_year = Date.today.year 
  when params[:m] && (requested_month > 12 || requested_month < 1)
    puts "#{requested_month} is  not a valid month number (1..12)"
    return
  when params[:m].nil? && requested_year >= 1 && requested_year <= 9999
    puts "you can specify a month by using `-m' as an option"
    return
  when  params[:y].nil? && params[:m].nil? 
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
    (1..end_of_month).each do |day|
      if requested_month == this_month && requested_year == this_year && day == thisday
        print "\e[30m\e[47m#{day.to_s.rjust(2)}\e[0m "
      else print day.to_s.rjust(2) + " "
      end
      if (day + starting_day) % 7 == 0
        puts
      end
    end
    puts
end
print_calendar
