arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

odd_arr = arr.select do |a|
  a % 2 != 0
end

#select iterates through each element of the array (arr) and returns true or false;
#here it returns a new array (odd_arr) comprised of the elements that returned true (numbers indivisible by 2)

p odd_arr

odd_arr = arr.select { |a| a.odd? } #same thing as above

p odd_arr