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
  
end
