require 'net/http'

url = URI.parse('http://data.sfgov.org/resource/bbb8-hzi6.json')
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
puts res.body