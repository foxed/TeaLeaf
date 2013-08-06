arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


arr.each {|a| puts a if a > 5 }

#or

arr.each do |a|
  puts a if a > 5
end