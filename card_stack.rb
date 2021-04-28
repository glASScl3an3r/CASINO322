# frozen_string_literal: true

class CardStack
  CARD_TYPES = %i[v2 v3 v4 v5 v6 v7 v8 v9 v10 J Q K A].freeze
  CARD_SUITS = %i[spades diamonds hearts clubs].freeze

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
      CARD_TYPES.each do |type|
        CARD_SUITS.each do |suit|
          @cards.push(Card.new(type, suit, value(type, suit)))
        end
      end
    end
    @cards.shuffle!
  end

  private

  def value(type, _suit)
    return 11 if type == :A

    [10, CARD_TYPES.index(type) + 2].min
  end
end
