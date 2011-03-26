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
