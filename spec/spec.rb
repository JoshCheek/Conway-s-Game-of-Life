require 'spec_helper'
require 'life'

describe GameOfLife do
  
  context 'when initialized with [0,0], [1,1]' do
    subject { GameOfLife.new [0,0] , [1,1] }
    specify { should      be_alive_at(0,0) }
    specify { should_not  be_alive_at(0,1) }
    specify { should_not  be_alive_at(1,0) }
    specify { should      be_alive_at(1,1) }
    
    context 'neigbors' do
      check_neighbors = lambda do |x,y,neighbors|
        specify do
          subject.neighbours(x,y).should equal(neighbors) ,
            "[#{x},#{y}] should have #{neighbors} neighbours"
        end
      end
      check_neighbors.call  -2,-2 , 0
      check_neighbors.call  -1,-1 , 1
      check_neighbors.call   0,0  , 1
      check_neighbors.call   1,1  , 1
      check_neighbors.call   0,1  , 2
      check_neighbors.call   1,0  , 2
      check_neighbors.call  10,0  , 0
      check_neighbors.call   0,10 , 0
    end
  end

end
