h = {:a=>1, :b=>2, :c=>3, :d=>4, :e=>5}

h.each do |k, v| #when you iterate thru a hash you have two values
  h.delete(k) if v < 3.5
  end
end

puts h

h.delete_if { |k, v| V < 3.5 }

puts h