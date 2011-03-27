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
    { "Rule 1: live cells with < 2 neighbours dies"               => [ [0,true,false] , [1,true,false] ],
      'rule 2: live cells with 2 or 3 neighbours lives'           => [ [2,true,true]  , [3,true,true]  ],
      'rule 3: live cells with more than 3 neighbours die'        => (4..8).map { |n| [n,true,false] },
      'rule 4: dead cells with 3 neighbours becomes alive'        => [[3,false,true]],
      'implicit rule: dead cells without 3 neighbours stay dead'  => [0,1,2,  4,5,6,7,8].map { |i| [i,false,false] },
    }.each do |rule,specifications|
      context rule do
        specifications.each do |n,initial_alive,final_alive|
          specify "#{initial_alive ? 'live' : 'dead'} cells with #{n} neighbours should be #{final_alive ? 'alive' : 'dead'} tomorrow." do
            cells = [ [-1,-1] , [0,-1] , [1,-1] ,
                      [-1, 0] ,          [1, 0] ,
                      [-1, 1] , [0, 1] , [1, 1] ][0...n]
            cells << [0,0] if initial_alive
            board = GameOfLife.new(*cells)
            board.should be_alive_at(0,0) if initial_alive
            board.neighbours(0,0).should equal(n)
            board.tick!
            final_alive ? board.should(be_alive 0 , 0) : board.should_not(be_alive 0 , 0)
          end
        end
      end
    end
  end
  
  describe "bounds" do
    context 'defaults to 60x40' do
      specify { subject.width.should  == 60 }
      specify { subject.height.should == 40 }
      it "should convert to a 60x40 nil array" do 
        subject.to_a.should == Array.new(40) { [nil]*60 }
      end
    end
  end
  
end
