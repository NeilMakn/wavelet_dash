require "net/http"

# list of URLs to check
url_list = [
  "http://www.crowdcompass.com",
  "http://www.crowdcompass.com/about.shtml",
  "http://www.crowdcompass.com/features",
  "http://www.google.com/doesnotexist",
  "http://www.google.com",
  "http://www.unvailabledomain123.org"
]
results = Hash.new({value: 0})

SCHEDULER.every '30s', :first_in => 0 do
  # connect to url and read HTTP response code
  def url_check(my_url)
    begin
      res = Net::HTTP.get_response(URI.parse(my_url.to_s))
      res.code
    rescue Exception
      "N/A"
    end
  end

  # go through list of URL's and get HTTP response code
  url_list.each do |url|
    results[url] = { label: url, value: url_check(url)}
  end 

  send_event('urlcheck', { items: results.values })
end