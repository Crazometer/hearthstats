class Arena < ActiveRecord::Base
  attr_accessible :userclass, :oppclass, :win, :gofirst
end
