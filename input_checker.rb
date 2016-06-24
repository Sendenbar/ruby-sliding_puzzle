class InputChecker
  def checkinput(m,n,array)
    array.sort == (0..m*n-1).to_a
  end
end
