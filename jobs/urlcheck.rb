require "net/http"

url_list = [
  "http://www.crowdcompass.com",
  "http://www.crowdcompass.com/shouldnotexist",
  "http://www.google.com/noway",
  "http://www.google.com",
  "http://localhost:4000",
  "http://www.lsjkfdljsf33.org"
]
results = Hash.new({value: 0})

SCHEDULER.every '5s' do
  def url_check(my_url)
    begin
      res = Net::HTTP.get_response(URI.parse(my_url.to_s))
      res.code
    rescue Exception
      false
    end
  end

  url_list.each do |url|
    results[url] = { label: url, value: url_check(url), color: "green" }
  end 
  send_event('urlcheck', { items: results.values })
end