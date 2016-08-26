require_relative 'GameState'

class Counter
  
  attr_reader :list_of_states
  
  def solve(rows, columns, on_the_fly = false)
    start_time = Time.new
    
    GameState.set_dimensions(rows, columns)
    state = GameState.new((1..(rows * columns)).to_a)
    
    #Initializing sets of states
    previous_states = Hash[state.permutation_number, state.clone]
    current_states = Hash.new
    state.get_neighbours.each {|neighbour| current_states[neighbour.permutation_number] = neighbour}
    future_states = Hash.new

    puts "0, 1", "1, " + current_states.size.to_s  if on_the_fly
    
    @list_of_states = [1, current_states.size]
    
    counter = 1  if on_the_fly
    
    while !current_states.empty? do 
     
      #Future_states will only include states with greater distance from solved state
      current_states.each_value do |state|
        state.get_neighbours.each do |neighbour|
          future_states[neighbour.permutation_number] = neighbour unless previous_states.include?(neighbour.permutation_number)
        end
      end

      @list_of_states << future_states.size unless future_states.empty?
      
      counter +=1 if on_the_fly
      puts counter.to_s + ", " + future_states.size.to_s if on_the_fly unless future_states.empty?

      previous_states, current_states, future_states = current_states, future_states, previous_states.clear
    end

    @list_of_states.each_with_index {|value, index| puts index.to_s + ", " + value.to_s} unless on_the_fly
    
    end_time=Time.new
    puts "Calculation took #{end_time-start_time} seconds."
  end
end


