arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

arr.each do |a|
  puts a
end

#'do end' is a block and can be substituted with curly braces

arr.each { |a| puts a } 
#if possible, put curly braces in one line; if you're using multiple lines, use 'do end'

