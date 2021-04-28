# frozen_string_literal: true

class Card
  attr_reader :type, :suit
  attr_accessor :value

  def initialize(type, suit, value)
    @type = type
    @suit = suit
    @value = value
  end
end
