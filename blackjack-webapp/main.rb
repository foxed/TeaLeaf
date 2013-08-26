require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do
  def calculate_total(cards) # cards is [["H", "3"], ["D", "J"], ... ]
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
  if player_total == 21
     @success = "#{session[:player_name]} has hit Blackjack! Congratulations!"
     @show_hit_or_stay = false
   elsif player_total > 21
    @error = "BUST! #{session[:player_name]} has exceeded 21."
    @show_hit_or_stay = false
  end
  
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:player_name]} has chosen to stay."
  @show_hit_or_stay = false

  redirect '/game/dealer'
end

get '/game/dealer' do
  @show_hit_or_stay = false

  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == 21 
    @error = "The dealer has hit 21, #{session[:player_name]} loses."
  elsif dealer_total > 21
    @success = "The dealer has busted! #{session[:player_name]} wins!"
  elsif dealer_total >= 17
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
    @success = "Congratulations, #{session[:player_name]} wins!"
  elsif dealer_total > player_total 
    @error = "Sorry, the dealer wins with a total of #{calculate_total(session[:dealer_cards])}."
  else
    @success = "Stalemate!"
  end

  erb :game

end



