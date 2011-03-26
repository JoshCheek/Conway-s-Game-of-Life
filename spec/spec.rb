require 'life'

describe GameOfLife do
  
  context 'when initialized with [0,0], [1,1]' do
    before { @board = GameOfLife.new [0,0] , [1,1] }
    specify '[0,0] should be alive' do
      @board.should be_alive(0,0)
    end
    specify '[0,1] should not be alive' do
      @board.should_not be_alive(0,1)
    end
    specify '[1,0] should not be alive' do
      @board.should_not be_alive(1,0)
    end
    specify '[1,1] should not be alive' do
      @board.should be_alive(1,1)
    end
  end
  
end