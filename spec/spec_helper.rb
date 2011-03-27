RSpec::Matchers.define :be_alive_at do |x,y|
  
  match do |board|
    board.alive? x , y
  end  
  
  failure_message_for_should do
    "expected [#{x},#{y}] to be dead"
  end
  
  failure_message_for_should_not do
    "expected [#{x},#{y}] to be alive"
  end
  
  description do
    "be alive at [#{x},#{y}]"
  end

end


RSpec::Matchers.define :have_n_neighbors do |expected|
  
  x = y = observed = nil
  
  match do |new_x,new_y|
    x , y , observed = new_x , new_y , subject.neighbours(new_x,new_y)
    expected == observed
  end  
  
  failure_message_for_should do
    "expected [#{x},#{y}] to have #{expected} neighbors, got #{observed.inspect}"
  end
    
  description do
    "have #{expected} neighbors at [#{x},#{y}]"
  end
  
end


RSpec::Matchers.define :have_life_at do |*expected_life|
  
  actual_life = Array.new
  
  pretty = lambda { |ary| ary.map(&:inspect).join(' , ') }
  
  match do |board|
    board.to_a.each_with_index do |row,y|
      row.each_with_index do |element,x|
        actual_life << [x,y] if element
      end
    end
    actual_life.sort == expected_life.sort
  end
  
  failure_message_for_should do
    "expected life at #{pretty[expected_life]}\ngot life at #{pretty[actual_life]}"
  end
  
  description do
    "should be dead everywhere except #{pretty[expected_life]} should be alive"
  end
end


RSpec::Matchers.define :know_it_has_dimensions_of do |width,height|
  
  observed = { :width => nil   , :height => nil }
  expected = { :width => width , :height => height }
  
  match do |board|
    observed[:width]  = board.width
    observed[:height] = board.height
    expected == observed
  end
  
  failure_message_for_should do
    msg = []
    msg << "width should be #{expected[:width]} but is #{observed[:width]}" unless observed[:width] == expected[:width]
    msg << "width should be #{expected[:height]} but is #{observed[:height]}" unless observed[:height] == expected[:height]
    msg.join(" , ")
  end
  
  description do
    "know it has dimensions of #{width}x#{height}"
  end
  
end