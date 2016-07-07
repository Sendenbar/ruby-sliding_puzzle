class Heuristic
end

class ManhattanHeuristic
  def value(state)
    counter=0
    state.state_array.size.times do |index|
      counter +=((state.state_array[index]-1)/3 - index/3).abs + ((state.state_array[index]-1)%3 - index%3).abs unless state.state_array[index]==9
    end
    return counter
  end
end
