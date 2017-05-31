#!/usr/bin/env ruby

require 'net/http'
require 'optparse'
require 'date'
require 'json'
require 'formatador'


class API
  TZ = "-07:00"
  BASE_URL = "http://data.sfgov.org/resource/bbb8-hzi6.json"
  LIMIT = 10
  SELECTED_COLUMNS = "applicant, location"

  def initialize
    @skip_first_n = 0
  end

  def url
    timePST = Time.now.getlocal(TZ)
    time = timePST.strftime("%R")
    day = "?dayorder=#{timePST.wday}"
    sel = "&$select=#{SELECTED_COLUMNS}"
    order = "&$order=applicant"
    limit = "&$limit=#{LIMIT}"
    offset = "&$offset=#{@skip_first_n}"
    isopen = "&$where=start24<'#{time}' AND end24>'#{time}'"
    url = URI.parse(URI.escape(BASE_URL + day + sel + order + limit + offset + isopen))
    url
  end

  def get_open
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    data = JSON.parse(res.body)
    data.each do |f|
      f["NAME"] = f.delete("applicant")
      f["ADDRESS"] = f.delete("location")
    end
    data
  end

  def show_open
    Formatador.display_table(get_open, ["NAME", "ADDRESS"])
    @skip_first_n += LIMIT
  end
end

foodtrucks = API.new
foodtrucks.show_open
show_next = ""
while true
  puts "Show next 10? Y/N: "
  show_next = gets.chomp.downcase
  if show_next == "y"
    foodtrucks.show_open
  elsif show_next == "n"
    exit(0)
  else
    puts "Sorry, that is not a valid option. Show next 10? Y/N: "
    show_next = gets.chomp.downcase
  end
end
