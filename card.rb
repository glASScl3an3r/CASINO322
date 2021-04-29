# frozen_string_literal: true

class Card
  CARD_TYPES = %i[v2 v3 v4 v5 v6 v7 v8 v9 v10 J Q K A].freeze
  CARD_SUITS = %i[spades diamonds hearts clubs].freeze

  attr_reader :type, :suit
  attr_accessor :value

  def initialize(type, suit, value)
    @type = type
    @suit = suit
    @value = value
  end
end
