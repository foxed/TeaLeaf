require 'rubygems'
require 'sinatra'

set :sessions, true

BLACKJACK_AMT  = 21
DEALER_MIN_AMT = 17
helpers do
  def calculate_total(cards) 
    arr = cards.map{|element| element[1]}

    total = 0
    arr.each do |a|
      if a == "A"
        total += 11
       else
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    
    arr.select{|element| element == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def card_image(card)
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end

    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end

    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
  end

  def winner!(msg)
    @show_hit_or_stay = false
    @success="<strong>#{session[:player_name]} wins!</strong> #{msg}"
    @play_again = true     
  end

  def loser!(msg)
    @show_hit_or_stay = false
    @error="<strong>#{session[:player_name]} loses.</strong> #{msg}"
    @play_again = true  
  end

  def tie!(msg)
    @show_hit_or_stay = false
    @success="<strong>It's a tie.</strong> #{msg}"
    @play_again = true  
  end

end

before do
  @show_hit_or_stay = true
end

get '/' do
  if session[:player_name]
    redirect '/game'
   else 
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  if params[:player_name].empty?
    @error = "Please enter your name."
    halt erb(:new_player)
  end

  session[:player_name] = params[:player_name]
  redirect '/game'
end

get '/game' do
  session[:turn] = session[:player_name]

  suits = ['C', 'D', 'H', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'K', 'Q', 'A']
  session[:deck] = (suits.product(values)).shuffle!

  session[:player_cards] = []
  session[:dealer_cards] = []
  session[:player_cards] << session[:deck].pop 
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop


  erb :game
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop

  player_total = calculate_total(session[:player_cards])
  if player_total == BLACKJACK_AMT
     winner!("#{session[:player_name]} has hit Blackjack!")
    elsif player_total > BLACKJACK_AMT
    loser!("BUST! #{session[:player_name]}'s cards add up to #{player_total}.")
  end
  
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:player_name]} has chosen to stay."
  @show_hit_or_stay = false
  redirect '/game/dealer'
end

get '/game/dealer' do
  session[:turn] = "dealer"
  @show_hit_or_stay = false

  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == BLACKJACK_AMT 
    loser!("#{session[:player_name]} stayed at #{player_total}, and the dealer hit #{dealer_total}.")
  elsif dealer_total > BLACKJACK_AMT
    winner!("#{session[:player_name]} stayed at #{player_total}, and the dealer busted at #{dealer_total}.")
  elsif dealer_total >= DEALER_MIN_AMT
    redirect 'game/compare'
  else
    @show_dealer_hit = true
  end

  erb :game
end

post '/game/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  @show_hit_or_stay_buttons = false

  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])

  if player_total > dealer_total 
    winner!("#{session[:player_name]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
  elsif dealer_total > player_total 
    loser!("#{session[:player_name]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
  else
    tie!("Both #{session[:player_name]} and the dealer stayed at #{player_total}.")
  end

  erb :game
end

get '/game_over' do
  erb :game_over
end
