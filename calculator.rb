def say (msg)
	puts "=> #{msg}" 
end
 
say "Welcome to the calculator. To begin, please follow these basic instructions."
say "Input the first number." 

num1 = gets.chomp

say "Input the second number."
num2 = gets.chomp

say "What would you like to do with these numbers? 1) add 2) subtract 3) multiply 4) divide"

operator = gets.chomp

if operator == '1' 
	result = num1.to_i + num2.to_i
	operator = 'plus'
elsif operator == '2'
	result = num1.to_i - num2.to_i
	operator = 'minus'
elsif operator == '3'
	result = num1.to_i * num2.to_i
	operator = 'times'
elsif operator == '4'
	result = num1.to_f / num2.to_f 
	operator = 'divided by'

end


say "#{num1} #{operator} #{num2} equals #{result}."
