# frozen_string_literal: true

require_relative 'bank'
require_relative 'person'
require_relative 'card_stack'
require_relative 'card'
require_relative 'hand'

class Game
  include Bank

  # если вдруг не хватит того что предоставляет status
  attr_reader :dealer, :player, :card_stack, :round_num, :winner

  def initialize(bet_amount = 10, start_cash = 100)
    @bet = bet_amount
    @start_cash = start_cash
    @card_stack = CardStack.new
    new_session
  end

  def new_session
    @dealer = Person.new(@start_cash)
    @player = Person.new(@start_cash)
    @card_stack.shuffle
    @round_num = 0 # номер текущего раунда
    @winner = nil
    self.cash = 0
  end

  def round_started?
    # сбросить все карты до начала нового раунда
    @player.hand.clear
    @dealer.hand.clear
    # если в банке есть деньги, завершаем прошлый раунд
    end_round if cash != 0
    # победителя нет => продолжаем играть
    @winner = nil

    # если у игрока не хватает денег, то раунд не начался
    return false if @player.cash < @bet || @dealer.cash < @bet

    @round_num += 1
    # дилер и игрок получают по две карты
    2.times do
      @player.hand.get(@card_stack.next)
      @dealer.hand.get(@card_stack.next)
    end
    # делаем ставки в банк
    gain(@player.lose(@bet))
    gain(@dealer.lose(@bet))
    true
  end

  # данные для интерфейса
  def status
    {
      dealer_pts: @dealer.hand.score,
      dealer_hand: @dealer.hand.cards,
      dealer_bank: @dealer.cash,
      player_pts: @player.hand.score,
      player_hand: @player.hand.cards,
      player_bank: @player.cash,
      winner: @winner,
      round: @round_num,
      can_hit: !@player.hand.enough?,
      game_end: !@winner.nil?
    }
  end

  # получить карту
  def hit
    @player.hand.get(@card_stack.next) unless @player.hand.enough?
    dealer_turn
  end

  # пропустить ход
  def check
    dealer_turn
  end

  # отркрыть карты
  def cards_off
    dealer_turn # дадим дилеру сходить, если он не ходил
    end_round
  end

  private

  def dealer_turn
    @dealer.hand.get(@card_stack.next) if @dealer.hand.score < 17 && !@dealer.hand.enough?
  end

  def who_winner
    return :dealer if @player.hand.score > 21
    return :player if @dealer.hand.score > 21

    if @player.hand.score == @dealer.hand.score
      :draw
    elsif @player.hand.score > @dealer.hand.score
      :player
    else
      :dealer
    end
  end

  def end_round
    # определяем победителя
    @winner = who_winner
    # он получает деньги со стола
    case @winner
    when :player
      @player.gain(lose(cash))
    when :dealer
      @dealer.gain(lose(cash))
    else
      # если ничья, оба получают по половине банка
      half = cash / 2
      @dealer.gain(lose(half))
      @player.gain(lose(half))
    end
  end
end
