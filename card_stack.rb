# frozen_string_literal: true

class CardStack
  def initialize
    @cards = []
  end

  def next
    # если карт больше нет, намешаем новую колоду
    shuffle if @cards.length.zero?
    @cards.pop
  end

  # packs_count - число колод, которые замешаем
  def shuffle(packs_count = 1)
    @cards.clear
    (1..packs_count).each do
      Card::CARD_TYPES.each do |type|
        Card::CARD_SUITS.each do |suit|
          @cards.push(Card.new(type, suit, value(type, suit)))
        end
      end
    end
    @cards.shuffle!
  end

  private

  def value(type, _suit)
    return 11 if type == :A

    [10, Card::CARD_TYPES.index(type) + 2].min
  end
end
