require 'spec_helper'
require 'life'

describe GameOfLife do
  
  context 'when initialized with [0,0], [1,1]' do
    subject { GameOfLife.new [0,0] , [1,1] }
    it      { should      be_alive_at(0,0) }
    it      { should_not  be_alive_at(0,1) }
    it      { should_not  be_alive_at(1,0) }
    it      { should      be_alive_at(1,1) }
    
    context 'neigbours' do
      check_neighbours = lambda do |x,y,neighbours|
        specify do
          subject.neighbours(x,y).should equal(neighbours) ,
            "[#{x},#{y}] should have #{neighbours} neighbours"
        end
      end
      check_neighbours.call  -2,-2 , 0
      check_neighbours.call  -1,-1 , 1
      check_neighbours.call   0,0  , 1
      check_neighbours.call   1,1  , 1
      check_neighbours.call   0,1  , 2
      check_neighbours.call   1,0  , 2
      check_neighbours.call  10,0  , 0
      check_neighbours.call   0,10 , 0
    end
  end
  
end
