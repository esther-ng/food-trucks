#!/usr/bin/env ruby

require 'net/http'
require 'date'
require 'json'
require 'formatador'

class API
  TZ = "-07:00"
  BASE_URL = "https://data.sfgov.org/resource/bbb8-hzi6.json"
  LIMIT = 10
  SELECTED_COLUMNS = "applicant, location"

  def initialize
    @skip_first_n = 0
  end

  def show_open
    results = get_open
    if results.empty?
      Formatador.display_line("[red]-- END LIST --[/]")
      exit(0)
    end
    Formatador.display_table(results, ["NAME", "ADDRESS"])
    @skip_first_n += LIMIT
  end

  private

  def current_time
    Time.now.getlocal(TZ)
  end

  def formatted_time
    current_time.strftime("%R")
  end

  def today
    current_time.wday
  end

  def url
    day = "?dayorder=#{today}"
    sel = "&$select=#{SELECTED_COLUMNS}"
    order = "&$order=applicant"
    limit = "&$limit=#{LIMIT}"
    offset = "&$offset=#{@skip_first_n}"
    isopen = "&$where=start24<'#{formatted_time}' AND end24>'#{formatted_time}'"
    URI.parse(URI.escape(BASE_URL + day + sel + order + limit + offset + isopen))
  end

  def get_open
    req = Net::HTTP::Get.new(url.to_s)
    # req["X-App-Token"] = INSERT APP_TOKEN HERE TO PREVENT THROTTLING
    res = Net::HTTP.start(url.host, url.port, :use_ssl => true) {|http|
      http.request(req)
    }
    check_response(res)
    data = JSON.parse(res.body)
    data.each do |f|
      f["NAME"] = f.delete("applicant")
      f["ADDRESS"] = f.delete("location")
    end
    data
  end

  def check_response(res)
    if res.code == "429"
      puts "Your usage has been throttled by the San Francisco Data API. Please consider setting up an App Token to prevent throttling."
      exit(1)
    end
    unless res.is_a?(Net::HTTPSuccess)
      puts "Could not process request. Please try again later. #{res.code}"
      exit(1)
    end
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
    Formatador.display_line("[green]-- BON APPETIT! --[/]")
    exit(0)
  else
    puts "Sorry, that is not a valid option. Show next 10? Y/N: "
    show_next = gets.chomp.downcase
  end
end
