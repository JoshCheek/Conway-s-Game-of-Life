require 'life'

describe GameOfLife do
  
  context 'when initialized with [0,0], [1,1]' do
    subject { GameOfLife.new [0,0] , [1,1] }
    specify { should      be_alive(0,0) }
    specify { should_not  be_alive(0,1) }
    specify { should_not  be_alive(1,0) }
    specify { should      be_alive(1,1) }
    # specify '[0,0] should have one neighbour' do
    #   @board 
    # end
  end
  
end