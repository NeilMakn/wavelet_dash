# Wavelets calculations

# http://dmr.ath.cx/gfx/haar/

require 'prime'

class NotPowerOfTwoError < StandardError
end

class NotEvenNumberError < StandardError
end

module Wavelets

  ARRAY_SIZE_ERR_MSG = 'Array size %d is not a power of two.'
  
  def self.average(arr)
    # Find the average of the items in array.
    arr.empty? ? 0 : arr.inject(:+) / Float(arr.size)
  end

  def self.power_of_2_or_else (number, error_message="Number #{number} is not a power of 2.")
    # raises an error if number is not a power of 2, otherwise returns
    # log(number, 2).

    log2 = Math.log(number, 2)
    
    unless log2 % 1 == 0
      raise NotPowerOfTwoError, error_message
    end

    return log2.to_i
  end

  def self.even_number_or_else (number, error_message="Number #{number} is not even")
    # raises and error if number is not even, otherwise returns the
    # number of times number is divisable by 2.

    if number.even?
      twos = Prime.prime_division(number).first
      return twos[1]
    else
      raise NotEvenNumberError, error_message
    end
  end
  
  def self.haar(arr)
    # Haar transform an array of values.

    log2 = power_of_2_or_else(arr.size, ARRAY_SIZE_ERR_MSG % arr.size)
    
    haar = []
    log2.times do
      slices = arr.each_slice(2).to_a
      averages = slices.map { |slice| average(slice) }
      differences = slices.zip(averages).map { |slc, avg| slc[0] - avg }
      haar = differences + haar 
      arr = averages
    end
    return arr + haar
  end
  
  def self.raah(arr)
    # Reverse transform an array of Haar transformed values.
    
    log2 = Wavelets::power_of_2_or_else(arr.size, ARRAY_SIZE_ERR_MSG % arr.size)
    
    log2.times do |x|
      size = 2 ** x
      averages = arr.shift(size)
      differences = arr.shift(size)
      raah = averages.zip(differences).collect {|avg, dif|
        [avg + dif, avg - dif]}.flatten
      arr = raah + arr
    end
    return arr
  end

  def self.discrete_haar(data_array, steps=nil)
    # Step through Haar transform an array of values.
    max_steps = even_number_or_else(data_array.length)
    if steps.nil? or steps > max_steps
      steps = max_steps
    end
    
    discrete_haar = [data_array]
    steps.times do
      slices = data_array.each_slice(2).to_a
      averages = slices.map { |slice| average(slice) }
      differences = slices.zip(averages).map do |slice, mean|
        slice[0] - mean
      end
      discrete_haar.push(differences)
      data_array = averages
    end
    return discrete_haar
  end


  def self.discrete_graph(graph_data, steps=nil)
    max_steps = even_number_or_else(graph_data.length)
    if steps.nil? or steps > max_steps
      steps = max_steps
    end
    
    data_xmin = graph_data.first[:x]
    data_xmax = graph_data.last[:x]
    data_rmax = data_xmax - data_xmin
    discrete_haar = [graph_data]

    steps.times do |step|
      slices = graph_data.each_slice(2).to_a
      averages = slices.map.with_index do |slice, i|
        { :x => ((Float(data_rmax) / (data_rmax / (2 + 2 * step)) * i) + data_xmin),
          :y => average([slice.first[:y], slice.last[:y]]) }
      end
      differences = slices.zip(averages).map do |slice, mean|
        { :x => mean[:x],
          :y => (slice.first[:y] - mean[:y]).abs }
      end
      discrete_haar.push(differences)
      graph_data = averages
    end

    # If the discrete wavelet graph goes through all the steps, the
    # last wavelet will have one less datapoint. This pushes an extra
    # data point to the end with the same value as the last one. 
    if steps == max_steps
      discrete_haar.last.push({ :x => data_xmax,
                                :y => discrete_haar.last.last[:y]})
    end
    # FIXME, perhaps this should be done in the dashing job that uses
    # wavelets, rather than here.
    return discrete_haar
  end
  
  # end of module
end
