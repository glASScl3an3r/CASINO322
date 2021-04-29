# frozen_string_literal: true

class Person
  include Bank

  attr_reader :cards, :hand

  def initialize(cash = 0)
    @hand = Hand.new
    gain(cash)
  end
end
