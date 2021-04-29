# frozen_string_literal: true

class Hand
  attr_reader :cards

  def initialize
    @cards = []
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
    while pts > 21 && ace_count.positive?
      pts -= 10
      ace_count -= 1
    end
    pts
  end

  def enough?
    @cards.length == 3
  end
end
