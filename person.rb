# frozen_string_literal: true

class Person
  include Bank

  attr_reader :cards

  def initialize(cash = 0)
    @cards = []
    gain(cash)
  end

  def get(card)
    @cards.push(card)
  end

  def clear
    @cards.clear
  end

  def score
    pts = 0
    ace_count = 0
    @cards.each do |card|
      ace_count += 1 if card.type == :A
      pts += card.value
    end
    pts -= 10 while pts > 21 && ace_count.positive?
    pts
  end
end
