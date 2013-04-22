require 'URI'

# FIXME: Right now this just makes a URI object from a bare minimum of
# parameters. It may become more appropriate to extend the graphite
# objece and require it.

module DataServer
  def DataServer.new(args)
    scheme = args[:scheme]
    host   = args[:host]
    port   = args[:port] ||= nil
    path   = args[:path] ||= nil
    return URI::Generic.build(:scheme => scheme, :host => host,
                              :port => port, :path => path)
  end
end
