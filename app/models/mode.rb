class Mode < ActiveRecord::Base
  attr_accessible :name
  has_many :match
end
