require "./lib/graphite"
require './lib/data_server_conf'

# last started parkingsessions
SCHEDULER.every '1s', :first_in => 0 do
    # Create an instance of our helper class
    q = Graphite.new DataServerConf::GRAPHITE

    graphite_test_target = "derivative(carbon.agents.graphite_vagrant_crowdcompass_com-a.cache.queries)"

    # get the current value
    # current = q.value graphite_test_target, "-1min"
    # get points for the last half hour
    points = q.points graphite_test_target, "-10min"

    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event 'query_test', { points: points }
end
