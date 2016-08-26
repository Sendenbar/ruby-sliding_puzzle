require_relative '../GameState'
require_relative '../Counter'
require_relative '../factorial'
require_relative '../BFSSolver'
require 'test/unit'

class TestGameState < Test::Unit::TestCase
  
  def test_start_state_is_solvable_for_odd_squares
    [3, 5, 7, 9, 11].each do |i|
      GameState.set_dimensions(i, i)
      state = GameState.new((1..i**2).to_a)
      assert(state.solvable?, "Start state is not solvable!")
    end
  end

  def test_start_state_is_solvable_for_even_squares
    [2, 4, 6, 8, 10].each do |i|
      GameState.set_dimensions(i, i)
      state = GameState.new((1..i**2).to_a)
      assert(state.solvable?, "Start state is not solvable!")
    end
  end

  def test_shuffling_of_solvable_state_is_solvable
    GameState.set_dimensions(3, 3)
    10.times do
      state = GameState.new((1..9).to_a)
      state.random_move!(40)
      assert(state.solvable?, "Shuffling of solvable state is not solvable!(3x3)")
    end
    
    GameState.set_dimensions(4, 4)
    10.times do
      state = GameState.new((1..16).to_a)
      state.random_move!(40)
      assert(state.solvable?, "Shuffling of solvable state is not solvable!(4x4)")
    end
    
    GameState.set_dimensions(5, 5)
    10.times do
      state = GameState.new((1..25).to_a)
      state.random_move!(40)
      assert(state.solvable?, "Shuffling of solvable state is not solvable!(5x5)")
    end
  end

  def test_shuffling_of_unsolvable_state_is_unsolvable
    GameState.set_dimensions(3, 3)
    10.times do
      state = GameState.new([1, 2, 3, 4, 5, 6, 8, 7, 9])
      state.random_move!(40)
      assert(!state.solvable?, "Shuffling of unsolvable state is solvable!(3x3)")
    end
    
    GameState.set_dimensions(4, 4)
    10.times do
      state = GameState.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 14, 16])
      state.random_move!(40)
      assert(!state.solvable?, "Shuffling of unsolvable state is solvable!(4x4)")
    end
    
    GameState.set_dimensions(5, 5)
    10.times do
      state = GameState.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 23, 25])
      state.random_move!(40)
      assert(!state.solvable?, "Shuffling of unsolvable state is solvable!(5x5)")
    end
  end

end

class TestCounter < Test::Unit::TestCase
  
  def test_counter_counts_properly
    counter = Counter.new
   
    # Actually pretty long test (like 18s?)
    counter.solve(3, 3)
    assert_equal(counter.list_of_states, [1, 2, 4, 8, 16, 20, 39, 62, 116, 152, 286, 396, 748, 1024, 1893, 2512, 4485, 5638, 9529, 10878, 16993, 17110, 23952, 20224, 24047, 15578, 14560, 6274, 3910, 760, 221, 2])
    
    counter.solve(7, 1)
    assert_equal(counter.list_of_states, [1, 1, 1, 1, 1, 1, 1])

    counter.solve(2, 2)
    assert_equal(counter.list_of_states, [1, 2, 2, 2, 2, 2, 1])
  end

end

class TestBFSSolver < Test::Unit::TestCase
  
  def test_BFSSolver_finds_shortest_path 
    solver = BFSSolver.new

    solver.solve(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    assert_equal("", solver.end_state.path, "Path to solved state longer than 0.")
    
    solver.solve(3, 3, [1, 2, 3, 4, 5, 6, 7, 9, 8])
    assert_equal(1, solver.end_state.distance, "Wrong path length.")

    solver.solve(3, 3, [1, 2, 3, 9, 5, 6, 4, 7, 8])
    assert_equal(3, solver.end_state.distance, "Wrong path length.")

    solver.solve(2, 2, [3, 1, 4, 2])
    assert_equal(3, solver.end_state.distance, "Wrong path length.")
  end
end
