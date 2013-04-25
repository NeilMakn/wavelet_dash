# Wavelets tests

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

require_relative './wavelets'


describe "Wavelets tests" do

  haar = [7, 1,  6,  6, 3, -5, 4, 2]
  raah = [3, 2, -1, -2, 3,  0, 4, 1]

  discrete_haar = [haar, [3, 0, 4, 1], [-1, -2], [2]]
  
  graph = [{:x => 0, :y => 7}, {:x => 1, :y => 1},
           {:x => 2, :y => 6}, {:x => 3, :y => 6},
           {:x => 4, :y => 3}, {:x => 5, :y => -5}, 
           {:x => 6, :y => 4}, {:x => 7, :y => 2}]
  wave_graph = [graph,
                [{:x=>0.0, :y=>3.0}, {:x=>2.3333333333333335, :y=>0.0},
                 {:x=>4.666666666666667, :y=>4.0}, {:x=>7.0, :y=>1.0}],
                [{:x=>0.0, :y=>-1.0}, {:x=>7.0, :y=>-2.0}],
                [{:x=>0.0, :y=>2.0}, {:x=>7, :y=>2.0}]]
  
  it "should turn the seq #{haar} into seq #{raah}" do
    Wavelets.haar(haar).must_equal raah
  end

  it "should turn the seq #{raah} into seq #{haar}" do
    Wavelets.raah(raah).must_equal haar
  end

  it "should raise NotPowerOfTwo when array.size is not a power of two" do
    proc { Wavelets.haar(haar[0...-1]) }.must_raise NotPowerOfTwoError
    proc { Wavelets.raah(raah[0...-1]) }.must_raise NotPowerOfTwoError
  end

  it "should generate list of haar wavelets" do
    Wavelets.discrete_haar(haar).must_equal discrete_haar
  end

  it "should generate a graph list of haar wavelets" do
    Wavelets.discrete_graph(graph).must_equal wave_graph
  end
end

