# frozen_string_literal: true

require_relative 'game'

class Interface
  def initialize(game)
    @game = game
  end

  def Start
    print 'Your name: '
    @name = gets.chomp
    puts "Hello, #{@name}! Good luck!"
    main_loop
  end

  private

  def main_loop
    # для каждого раунда
    while true
      # если не получилось запустить новый раунд => у игрока(или дилера) нет денег
      break unless @game.round_started?

      status = @game.status
      puts "Round #{status[:round]}"
      puts 'Bets are off!'
      print_banks(status)
      # для каждого действия игрока
      loop do
        status = @game.status
        #есть победитель?
        unless status[:winner].nil?
          print_table(status, false)
          winner = 'No one'
          winner = @name if status[:winner] == :player
          winner = 'Dealer' if status[:winner] == :dealer
          puts "Winner: #{winner}"
          # чтобы можно было успеть посмотреть результаты
          sleep(2)
          break
        end
        print_table(status)
        handle_options(status)
      end
      puts "\e[H\e[2J" # очистить экран(linux only)
    end
    status = @game.status
    if (status[:player_bank]).zero?
      puts "Good luck next time, #{@name}!"
    else
      puts "You won this time, #{@name}!"
    end
  end

  # closed - закрыть ли карты дилера?
  def print_table(status, closed = true)
    d_hand = status[:dealer_hand]
    p_hand = status[:player_hand]
    puts '=' * 20
    print 'Dealer hand: '
    d_hand.each do |card|
      print_card(card, closed)
    end
    puts
    print "#{@name} hand:   "
    p_hand.each do |card|
      print_card(card, false)
    end
    puts
    puts '=' * 20
    puts "#{@name} score: #{status[:player_pts]}"
    puts "Dealer score #{status[:dealer_pts]}" unless closed
    puts
  end

  def print_banks(status)
    puts "#{@name} cash: #{status[:player_bank]}$"
    puts "Dealer cash: #{status[:dealer_bank]}$"
  end

  def handle_options(status)
    puts '1 - check'
    puts '2 - show cards'
    puts '3 - hit' if status[:can_hit]
    inp = gets.chomp.to_i
    if inp == 1
      @game.check
    elsif inp == 2
      @game.cards_off
    elsif inp == 3 && status[:can_hit]
      @game.hit
    else
      puts 'Unknown command. Try again'
    end
  end

  def print_card(card, closed = true)
    if closed
      print '|**| '
    else
      suit = ''
      suit = case card.suit
             when :spades
               '♠'
             when :hearts
               '♥'
             when :diamonds
               '♦'
             when :clubs
               '♣'
             else
               '*'
             end
      type = card.type.to_s[-1]
      # десятку в один символ
      type = '⑩' if card.type == :v10
      print "|#{type}#{suit}| "
    end
  end
end
