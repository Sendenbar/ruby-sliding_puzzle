require '../GameState'
require 'test/unit'

class TestGameState < Test::Unit::TestCase
  
  def test_start_state_is_solvable_for_odd_squares
    [3,5,7,9,11].each do |i|
      state = GameState.new(i,i,(1..i**2).to_a)
      assert(state.solvable?, "Start state is not solvable!")
    end
  end

  def test_start_state_is_solvable_for_even_squares
    [2,4,6,8,10].each do |i|
      state = GameState.new(i,i,(1..i**2).to_a)
      assert(state.solvable?, "Start state is not solvable!")
    end
  end

  def test_shuffling_of_solvable_state_is_solvable
    10.times do
      state = GameState.new(3,3,(1..9).to_a)
      40.times do 
        state.random_move!
      end
      assert(state.solvable?, "Shuffling of solvable state is not solvable!(3x3)")
    end
    
    10.times do
      state = GameState.new(4,4,(1..16).to_a)
      40.times do 
        state.random_move!
      end
      assert(state.solvable?, "Shuffling of solvable state is not solvable!(4x4)")
    end
    
    10.times do
      state = GameState.new(5,5,(1..25).to_a)
      40.times do 
        state.random_move!
      end
      assert(state.solvable?, "Shuffling of solvable state is not solvable!(5x5)")
    end
  end

  def test_shuffling_of_unsolvable_state_is_unsolvable
    10.times do
      state = GameState.new(3,3,[1,2,3,4,5,6,8,7,9])
      40.times do 
        state.random_move!
      end
      assert(!state.solvable?, "Shuffling of unsolvable state is solvable!(3x3)")
    end
    
    10.times do
      state = GameState.new(4,4,[1,2,3,4,5,6,7,8,9,10,11,12,13,15,14,16])
      40.times do 
        state.random_move!
      end
      assert(!state.solvable?, "Shuffling of unsolvable state is solvable!(4x4)")
    end
    
    10.times do
      state = GameState.new(5,5,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,24,23,25])
      40.times do 
        state.random_move!
      end
      assert(!state.solvable?, "Shuffling of unsolvable state is solvable!(5x5)")
    end
  end
end
