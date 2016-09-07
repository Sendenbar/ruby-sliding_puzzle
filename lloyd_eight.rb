require 'pry'
require_relative 'heuristics'
require_relative 'PriorityQueue'
require_relative 'GameState'
require_relative 'factorial'
require_relative 'BFSSolver'
require_relative 'Counter'
require_relative 'AStarSolver'


a=(1..9).to_a

#counter=Counter.new
#counter.set_start_state
#counter.solve
#counter.solve(7,1,true)
#list=counter.list_of_states
# puts list[10]
# h=ManhattanHeuristic.new
# state = GameState.new(3,3,a.clone)
solver = AStarSolver.new
5.times do 
  solver.solve(3,3,[9, 8, 7, 6, 5, 4, 3, 2, 1], ManhattanHeuristic)
end

solver = BFSSolver.new
5.times do 
  solver.solve(3,3,[9, 8, 7, 6, 5, 4, 3, 2, 1])
end


#state.print_state

#state = GameState.new(4,3,(1..12).to_a)
#state.print_state

#state = GameState.new(3,4,(1..12).to_a)
#state.print_state


#  solver=BFSGameSolver.new
#  solver.set_start_state(4,4,(1..16).to_a)
#  solver.start_state.random_move!(10)
#  solver.start_state.print_state
#  puts "Mělo by stačit #{list[solver.start_state.permutation_number]} kroků..."
#  solver.solve
#  solver=AStarGameSolver.new
#  solver.set_start_state(a,h)
#  solver.start_state.print_state
#  puts "Mělo by stačit #{list[solver.start_state.permutation_number]} kroků..."
#  puts "Heuristika: #{h.value(solver.start_state)}"
#  solver.solve
