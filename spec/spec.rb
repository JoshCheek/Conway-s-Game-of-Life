require 'spec_helper'
require 'life'

describe GameOfLife do
  
  context 'when initialized with [0,0], [1,1]' do
    subject { GameOfLife.new [0,0] , [1,1] }
    specify { should      be_alive_at(0,0) }
    specify { should_not  be_alive_at(0,1) }
    specify { should_not  be_alive_at(1,0) }
    specify { should      be_alive_at(1,1) }
  end

end
