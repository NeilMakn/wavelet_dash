require "./lib/graphite"
require './lib/data_server_conf'

# begin scheduler
SCHEDULER.every '1s', :first_in => 0 do
  # Create an instance of our helper class
  q = Graphite.new DataServerConf::GRAPHITE

  graphite_test_target = "graphite.com.crowdcompass.vagrant.graphite.cpu.0.idle"

  # get the current value
  current_value = q.value graphite_test_target, "-2min"
  # find set of data preceding current  value
  data_set = q.points graphite_test_target, "-2min"
  # find first value's y
  prev_value = data_set[0][:y]
  # set threshold
  threshold_set = 50

  # send to dashboard, so the number the meter and the graph widget can understand it
  send_event 'graphite_test', { current: current_value, last: prev_value, threshold: threshold_set }
end
