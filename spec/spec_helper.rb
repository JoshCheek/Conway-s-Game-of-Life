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