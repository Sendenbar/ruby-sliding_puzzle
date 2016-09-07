class Heuristic
end

class ManhattanHeuristic
  def self.distance(state)
    columns = GameState.columns
    counter = 0
    state.state_array.each_with_index do |value, index|
      counter += ((value - 1) / columns - index / columns).abs + ((value - 1) % columns - index % columns).abs unless value == GameState.empty
    end
    return counter
  end
end
