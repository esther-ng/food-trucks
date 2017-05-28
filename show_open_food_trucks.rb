require 'net/http'
require 'optparse'
require 'date'
require 'json'
require 'formatador'

TZ = "-07:00"
base_url = 'http://data.sfgov.org/resource/bbb8-hzi6.json'
now = Time.now
timePST = now.getlocal(TZ)
time = timePST.strftime("%R")
day = "?dayorder=#{timePST.wday}"
sel = "&$select=applicant,location"
order = "&$order=applicant"
limit = "&$limit=10"
isopen = "&$where=start24<'#{time}' AND end24>'#{time}'"
url = URI.parse(URI.escape(base_url + day + sel + order + limit + isopen))

req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}

data = JSON.parse(res.body)
data.each do |f|
  f["NAME"] = f.delete("applicant")
  f["ADDRESS"] = f.delete("location")
end
Formatador.display_table(data, ["NAME", "ADDRESS"])
