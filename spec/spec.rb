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
      specify { [-2,-2].should have_n_neighbors(0) }
      specify { [-1,-1].should have_n_neighbors(1) }
      specify { [ 0,0 ].should have_n_neighbors(1) }
      specify { [ 1,1 ].should have_n_neighbors(1) }
      specify { [ 0,1 ].should have_n_neighbors(2) }
      specify { [ 1,0 ].should have_n_neighbors(2) }
      specify { [10,0 ].should have_n_neighbors(0) }
      specify { [ 0,10].should have_n_neighbors(0) }
    end
  end
  
  context 'when initialized with a 9 cell block' do
    subject { GameOfLife.new [0,0] , [1,0] , [2,0],
                             [0,1] , [1,1] , [2,1],
                             [0,2] , [1,2] , [2,2] }
    (0...9).zip([3,5,3, 5,8,5, 3,5,3]) do |i,n|
      x , y = i%3 , i/3
      it { should be_alive_at(x,y) }
      specify { [x,y].should have_n_neighbors(n) }
    end
  end
  
  
  describe '#tick!' do
    context 'rule 1: live cells with < 2 neighbours dies' do
      it 'dies with 0 neighbours' do
        board = GameOfLife.new [0,0]
        board.tick!
        board.should_not be_alive(0,0)
      end
      it 'dies with 1 neighbour' do
        board = GameOfLife.new [0,0] , [0,1]
        board.tick!
        board.should_not be_alive(0,0)
      end
    end
    
    context 'rule2: live cells with 2 or 3 neighbours lives' do
      it 'lives with 2 neighbours' do
        board = GameOfLife.new [0,0] , [0,1] , [1,0] 
        board.tick!
        board.should be_alive(0,0)
      end
      it 'lives with 3 neighbours' do
        board = GameOfLife.new [0,0] , [0,1] , [1,0] , [1,1]
        board.tick!
        board.should be_alive(0,0)
      end
    end
  end
end
