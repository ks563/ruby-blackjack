BLACKJACK = 21

class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end

  def to_s
    "#{name} of #{suit}"
  end
end

class Deck
  attr_accessor :playable_cards
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITS.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class BustError < StandardError;
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
    @done = false
  end

  def draw(card)
    @cards << card
    raise BustError.new("Went over") if value > BLACKJACK
  end
end

  def value
    cards.map(&:value).sum
  end

  def show
    cards.each do |card|
      p card.to_s
    end
  end

  def reset
    @done = false
  end

  def done?
    @done
  end

  def prompt
    puts "Would you like to hit or stay?"
    response = gets.chomp
    @done = response == "stay"
  end
end

class View
  def self.game_over(player_name)
    puts "#{player_name} went bust"
  end
end



class Game
    attr_accessor :player_hand, :dealer_hand, :deck
    def initialize
      deck = Deck.new
      player_hand = Hand.new
      dealer_hand = Hand.new
      
      players = [player_hand, dealer_hand]
      game_play()
    end

      
  
   def game_play
      loop do
        dealer_hand.show # see dealer hand
      
        players.each_with_index do |player, index| # draw cards
          player.reset
          begin
            until player.done?
              player.draw(deck.deal_card)
              player.draw(deck.deal_card)
      
              player.prompt
          end
        rescue BustError => e
          player_name = index ? "Dealer" : "Player"
        View.game_over
        players.delete_at(index)
      end
      end
      
      puts "Player: #{player_hand.value} Dealer: #{dealer_hand.value}"
      end

    end
  

  




  def draw(playable_cards)
    @player_hand.draw(@playable_cards)
  end

  def stand
    @dealer_hand.dealer_turn
    @winner = check_result(@player_hand.value, @dealer_hand.value)
  end

  def dealer_turn(playable_cards)
    if @dealer_hand_value <= 17
      draw(playable_cards)
      dealer_turn(playable_cards)
    end
  end

  def current_result
    #need to check value of cards to check bust or blackjack
    {:player_cards => @player_hand.cards,
      :player_card_value => @player_value,
      :dealer_cards => @dealer_hand.cards,
      :dealer_card_value => @dealer_value,
      :winner => @winner}
    end

  def check_result(player_value, dealer_value)
    if player_value == BLACKJACK
      return :playerblackjack!
    end
    if player_value > BLACKJACK
      #player bust
      return :dealer 
    end
    if dealer_value > BLACKJACK
      #dealer bust
      return :player
    end
    if player_value > dealer_value
     :player
    else
      return :dealer
    end
    if player_value == dealer_value
      return :tie
    end
    
  end
end
