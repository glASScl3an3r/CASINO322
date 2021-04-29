# frozen_string_literal: true

module Bank
  attr_accessor :cash

  def gain(cash)
    self.cash ||= 0
    self.cash += cash.to_i
  end

  def lose(cash)
    was = self.cash
    # если не хватает денег на новую ставку, то берем то что осталось
    self.cash = [0, self.cash - cash.to_i].max
    was - self.cash
  end
end
