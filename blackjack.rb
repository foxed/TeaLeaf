#Calculates total of cards
def calculate_total(cards)
 arr = cards.map{|e| e[1]}
 total = 0

 arr.each do |value|
 	if value.to_i == 0
 		total += 10
 	elsif value == "A"
 		total += 11
 	else
 		total += value.to_i 
 	end
 
  arr.select{|e| e == "A"}.count.times do
    total -= 10 if total > 21
  end

  total
end


 total
 
end

suits = ['C', 'D', 'H', 'S']
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'K', 'Q', 'A']
deck = suits.product(cards) #when i had this switched around, it threw EVERYTHING off in the calculate_total method, the cards always added up to 20. why? 

deck.shuffle!

player_cards=[]
dealer_cards=[]

p "Welcome to blackjack! Dealing your cards now..."

#Dealing cards
player_cards << deck.pop 
player_cards << deck.pop
dealer_cards << deck.pop
dealer_cards << deck.pop


dealer_total=calculate_total(dealer_cards)
player_total=calculate_total(player_cards)



p "Your cards are #{player_cards[0]} and #{player_cards[1]}. These cards add up to #{player_total}."
p "One of the dealer's cards is #{dealer_cards[0]}."


while player_total < 21 
#Player's turn
 puts 'Would you like to hit or stay?'
 response = gets.chomp.downcase	
 if response == 'stay'
   puts "You chose to stay, your cards remain at a total of #{player_total}."
 break
 end

 if response == 'hit'
     new_card = deck.pop
     player_cards << new_card
	 puts "You have just been dealt #{new_card}."
     player_total = calculate_total(player_cards)
	 puts "Your cards now add up to #{player_total}."
	   if player_total > 21
       puts "Sorry, you have lost, you are over 21."
       exit
     elsif player_total == 21
       puts "Your total is 21! CONGRATS!! You win!"
       exit
     end
	end
end

#Dealer's turn
while dealer_total < 17
   new_card = deck.pop
   dealer_cards << new_card
   dealer_total=calculate_total(dealer_cards) 
    puts "The dealer is now at #{dealer_total}, after being dealt a #{new_card}."
  
  if dealer_total == 21
		puts "Sorry, you have lost, the dealer has hit blackjack."
    puts "The dealer's cards: #{dealer_cards[0]}, #{dealer_cards[1]}, #{dealer_cards[2]} equal #{dealer_total}."
    exit
  elsif dealer_total > 21
		puts 'The dealer is over 21, you win!'
    exit
  end
end

#Comparing hands
while dealer_total && player_total <=21
  if dealer_total > player_total && dealer_total < 22
      puts "Dealer's total is #{dealer_total}. Player's total is #{player_total}. The dealer wins."
      break
  elsif player_total > dealer_total && player_total < 22
      puts "Player's total is #{player_total}. Dealer's total is at #{dealer_total}. The player wins!"
      break
  else player_total == dealer_total
      puts "Ah, you have #{player_total} and the dealer has #{dealer_total} -- it's a stalemate."
      exit
  end
end


