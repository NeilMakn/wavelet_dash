Check out http://shopify.github.com/dashing for more information.

To configure your servers create a file called `lib/data_server_conf.rb` with content like the following:

```ruby
require './data_server'

module DataServerConf
  GRAPHITE = DataServer.new(:scheme => 'http', :host => 'localhost',
                        :port => 9999, :path => '/graphite')
end
```

Your dashing jobs will be able to `require './lib/data_server_conf'` and refer to specific data servers with something like `DataServerConf::GRAPHITE`. Right now, the object returned by `DataServer.new` is a URI object and can be used as such right after. <http://ruby-doc.org/stdlib-1.9.2/libdoc/uri/rdoc/URI.html>
