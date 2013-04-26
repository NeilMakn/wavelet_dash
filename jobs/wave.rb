require "./lib/graphite"
require "./lib/wavelets.rb"
require './lib/data_server_conf'

# last started parkingsessions
SCHEDULER.every '1m', :first_in => 0 do
  # Create an instance of our helper class
  q = Graphite.new DataServerConf::GRAPHITE
  
  graphite_test_target = 'graphite.com.crowdcompass.vagrant.graphite.cpu.0.wait'
  
  # get the current value
  # current = q.value(graphite_test_target, '-1min')
  
  # get wavelet of points for the last half hour
  points = Wavelets.discrete_graph(q.points(graphite_test_target,
                                            "-24min"), 1).last
  
  # send to dashboard, so the number the meter and the graph widget
  # can understand it
  send_event('graphite_wave_test', points: points)
end
