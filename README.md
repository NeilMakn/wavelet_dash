Check out http://shopify.github.com/dashing for more information.

To configure your servers create a file called `lib/data_server_conf.rb` with content like the following:

```ruby
require './data_server'

module DataServerConf
  GRAPHITE = DataServer.new(:scheme => 'http', :host => 'localhost',
                        :port => 8888, :path => '/graphite',
						:user => 'user:pass')
end
```

Your dashing jobs will be able to `require './lib/data_server_conf'` and refer to specific data servers with something like `DataServerConf::GRAPHITE`. Right now, the object returned by `DataServer.new` is a URI object and can be used as such right after. <http://ruby-doc.org/stdlib-1.9.2/libdoc/uri/rdoc/URI.html>

####

Below is the code for starting a new job that tracks current graph points from graphite
Query is based on graphite's URL API, check out:
http://graphite.readthedocs.org/en/1.0/url-api.html#json

example query:
http://graphite/render?format=json&target=graphite.app.user.visits&from=-24min

#your_metric.rb

```

require "./lib/graphite"
require './lib/data_server_conf'

# begin scheduler, choose frequency.
SCHEDULER.every '1s', :first_in => 0 do
  # Create an instance of our helper class
  q = Graphite.new DataServerConf::GRAPHITE

  graphite_test_target = "graphite.app.user.visits"

  # get the current value, and set time sample.
  current_value = q.value graphite_test_target, "-5min"
  # get data set preceding current value, and set time sample.
  data_set = q.points graphite_test_target, "-5min"
  # find first data point y value
  prev_value = data_set[0][:y]
  # set threshold
  threshold_set = 1,000


  # send to dashboard, so the number the number and the graph widget can understand it
  send_event 'send_visits', { current: current_value, last: prev_value, threshold: threshold_set }
end
```

Making widget in HTML

Each new widget is a list item.
See Dashing's doc for how to layout.

-Set data-id to send_event from your_metric.rb. ('send_visits')
-Set data-view to render correct widget for threshold
-Set data-operator to specify if you are checking for your metrics to be
greater or lesser than threshold_set. ('lesser' will notify if current data is less than 1,000)


#dashboard.erb

```

<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="send_visits" data-view="Threshold" data-title="Visits Today" data-operator="lesser" style="background-color: #4FD5D6"></div>
</li>


```

