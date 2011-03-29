require 'spec_helper'
require 'game_of_life'

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
  
  context 'when initialized with an options hash for width' do
    it 'should know its width' do
      GameOfLife.new(:width => 111).width.should == 111
      GameOfLife.new([1,1],:width => 111).width.should == 111
    end
    it 'should know its height' do
      GameOfLife.new(:height => 111).height.should == 111
      GameOfLife.new([1,1],:height => 111).height.should == 111
    end
    it 'should know ts width and height' do
      GameOfLife.new(:width => 111 , :height => 222).should know_it_has_dimensions_of(111,222)
      GameOfLife.new([1,1],[2,2],[12,34],:width => 111 , :height => 222).should know_it_has_dimensions_of(111,222)
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
    it 'returns the game' do
      subject.tick!.should == subject
    end
  end
  
  describe "bounds" do
    context 'defaults to 60x40' do
      it { should know_it_has_dimensions_of(60,40) }
      it { should have_life_at() }
    end
    context '10x10' do
      subject { game = GameOfLife.new; game.width = game.height = 10; game }
      it { should know_it_has_dimensions_of(10,10) }
      it { should have_life_at() }
    end
    context '5x10 array with life at [1,1] , [4,8]' do
      subject { GameOfLife.new [1,1] , [4,8] , :width => 5 , :height => 10 }
      it { should know_it_has_dimensions_of(5,10) }
      describe '#to_a' do
        specify { subject.to_a.should have(10).columns }
        it('should have 5 rows') { subject.to_a.should be_all { |row| row.size == 5 } }
        it { should have_life_at([1,1] , [4,8]) }
      end
    end
  end
  
  describe 'several iterations of 6x6, seeded with [1,1] , [2,1] , [2,2] , [3,2] , [2,3] , [3,3]' do
    initial_game = lambda { GameOfLife.new [1,1] , [2,1] , [2,2] , [3,2] , [2,3] , [3,3] , :width => 6 , :height => 6 }
    subject { initial_game.call }
    it { should know_it_has_dimensions_of(6,6) }
    it { should have_life_at([1,1] , [2,1] , [2,2] , [3,2] , [2,3] , [3,3]) }
    context 'after one tick' do
      subject { initial_game.call.tick! }
      it { should have_life_at([1,1],[2,1],[3,1],[2,3],[3,3]) }
    end
    context 'after two ticks' do
      subject { initial_game.call.tick!.tick! }
      it { should have_life_at([2,0],[2,1],[1,2]) }
    end
    context 'after three ticks' do
      subject { initial_game.call.tick!.tick!.tick! }
      it { should have_life_at([1,1],[2,1]) }
    end
    context 'after four ticks' do
      subject { initial_game.call.tick!.tick!.tick!.tick! }
      it { should have_life_at() }
    end
  end

  describe '.[]' do
    specify { GameOfLife[].should == GameOfLife.new }
    specify 'should construct a game from a map' do
      GameOfLife["x..\n.x.\n..x"].should == GameOfLife.new([0,0],[1,1],[2,2], :width => 3 , :height => 3)
    end
    specify 'should allow any non period to be alive' do
      GameOfLife["9..\n.;.\n..p"].should == GameOfLife.new([0,0],[1,1],[2,2], :width => 3 , :height => 3)
    end
    specify 'should raise an error if rows are uneven' do
      lambda { GameOfLife[".\n.."] }.should raise_exception
    end
    specify 'should ignore whitespace'
  end
  
  describe '#==' do
    describe 'set based equality' do
      specify('[] == []'                            ) { GameOfLife.new.should                 ==  GameOfLife.new                }
      specify('[] != [[1,1]]'                       ) { GameOfLife.new.should_not             ==  GameOfLife.new([1,1])         }
      specify('[[12,21]] == [[12,21]]'              ) { GameOfLife.new([12,21]).should        ==  GameOfLife.new([12,21])       }
      specify('[[12,21]] != [[21,12]]'              ) { GameOfLife.new([12,21]).should_not    ==  GameOfLife.new([21,12])       }
      specify('[[12,21],[4,5]] == [[4,5],[21,12]]'  ) { GameOfLife.new([12,21],[4,5]).should  ==  GameOfLife.new([4,5],[12,21]) }
    end
    describe 'dimension based equality' do
      before { @a , @b = GameOfLife.new , GameOfLife.new }
      specify 'w10 == w10' do
        @a.width = @b.width = 10
        @a.should == @b
      end
      specify 'w10 != w20' do
        @a.width = 2 * (@b.width = 10)
        @b.should_not == @a
      end
      specify 'h111 == h111' do
        @a.height = @b.height = 111
        @a.should == @b
      end
      specify 'h111 != h222' do
        @a.height = 2 * (@b.height = 111)
        @b.should_not == @a
      end
    end
    describe 'set and dimensions' do
      subject { GameOfLife.new [1,1] , :width => 10 , :height => 5 }
      specify('[1,1]10x5 == [1,1]10x5') { should      == GameOfLife.new( [1,1] , :width => 10 , :height => 5 ) }
      specify('[1,1]10x5 != [1,1]10x4') { should_not  == GameOfLife.new( [1,1] , :width => 10 , :height => 4 ) }
      specify('[1,1]10x5 != [1,1]11x5') { should_not  == GameOfLife.new( [1,1] , :width => 11 , :height => 5 ) }
      specify('[1,1]10x5 != [1,2]10x5') { should_not  == GameOfLife.new( [1,2] , :width => 10 , :height => 5 ) }
    end
  end

end
