
class Card
  attr_accessor :suit, :face_value

  def initialize (s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
  	"The #{face_value} of #{find_suit}."
  end

  def to_s 
  	pretty_output
  end

  def find_suit
    ret_val = case suit
      when 'H' then 'Hearts'
      when 'D' then 'Diamonds'
      when 'C' then 'Clubs'
      when 'S' then 'Spades'
    end
  ret_val
  
  end

end


class Deck
  attr_accessor :cards

   def initialize 
   @cards = []
   ['H', 'D', 'S', 'C'].each do |suit|
   ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'King', 'Queen', 'Ace'].each do |face_value|
    @cards << Card.new(suit, face_value) #pushs actual cards into array
     end
    end

   shuffle!
  end

 def shuffle!
   cards.shuffle!
 end

 def deal_one
   cards.pop
 end

 def deck_size
  cards.size
 end

end

module Hand
  def show_hand
    puts "--#{name}'s hand --"
    cards.each do|card|
      puts "=>| #{card}"
    end #when this wasn't aligned properly, screwed up how cards were displayed
    puts  "=> Total: #{total}"
  end

  def add_card(new_card)
    cards << new_card
  end

  def total
   face_values = cards.map{|card| card.face_value}
   
   total = 0
   face_values.each do |value|
      if value.to_i == 0
        total += 10
      elsif value == "Ace"
        total += 11
      else
        total += value.to_i 
      end
  end
 
    face_values.select{|value| value == "Ace"}.count.times do
      total -= 10 if total > 21
    end

   total
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMT
  end

end
 

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize (n)
    @name = n
    @cards = []
  end

end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize 
    @name = "Dealer"
    @cards = []
  end
  
  def show_dealer_hand
    puts "-- Dealer --"
    puts "=>| Dealer's cards: ??? and #{@cards[1]}" 
  end

end

class Blackjack

  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck   = Deck.new
    @player = Player.new("Player")
    @dealer = Dealer.new 
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_hands
    puts player.show_hand
    puts dealer.show_dealer_hand
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMT
       if player_or_dealer.is_a?(Dealer)
         puts "Sorry, dealer hit blackjack, #{player.name} loses."
        else
         puts "Congratulations, #{player.name}, you hit blackjack!"
        play_again
       end
      
     elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
         puts "Dealer busted, you win!"
       else
         puts "Sorry, #{player.name} busted."
      play_again
      end

    end
  end


  def player_turn
    puts "#{player.name}'s turn."
    
    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "Would you like to 1)hit or 2)stay?"
      response = gets.chomp

      if !['1', '2'].include?(response)
        puts "Error, you must enter 1 or 2."
        next
      end

      if response == '2'
        puts "#{player.name} chose to stay."
        break
      end

        new_card = deck.deal_one
        puts "Dealing new card to #{player.name}: #{new_card}."
        player.add_card(new_card)
        puts player.show_hand

        blackjack_or_bust?(player)
    end

      puts "#{player.name} stays at #{player.total}."
  end

  def dealer_turn
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}."

      blackjack_or_bust?(dealer)
    end

    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total 
       puts "Congrats, #{player.name} wins!!!"
    elsif player.total < dealer.total
       puts "Sorry, #{player.name} loses."
    else
       puts "It's a tie!"
    play_again
    end

  end

  def play_again
    puts ""
    puts "Would you like to play again? 1) Yes 2) No"
    if gets.chomp == '1'
      puts "Starting new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start

    else
      puts "Goodbye. Exiting program."
      exit

    end
  end
  


  def start
    set_player_name
    deal_cards
    show_hands
    player_turn
    dealer_turn
    who_won?
    play_again
  end
end


game = Blackjack.new

game.start


