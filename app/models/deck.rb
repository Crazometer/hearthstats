class Deck < ActiveRecord::Base
  attr_accessible :loses, :name, :wins, :race
end
