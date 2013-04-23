require "./lib/graphite"
require './lib/data_server_conf'

# last started parkingsessions
SCHEDULER.every '30s', :first_in => 0 do
  # Create an instance of our helper class
  q = Graphite.new DataServerConf::GRAPHITE

    graphite_test_target = "graphite.com.crowdcompass.vagrant.graphite.cpu.0.idle"

    # get the current value
    current = q.value graphite_test_target, "-15min"
    # get points for the last half hour
    # points = q.points graphite_test_target, "-30min"
    last = current

    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event 'graphite_test', { current: current, last: last }
end
