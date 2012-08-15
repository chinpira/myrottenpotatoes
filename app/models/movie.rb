class Movie < ActiveRecord::Base
  def self.possible_ratings
    self.select(:rating).map(&:rating).uniq.sort
  end
end
