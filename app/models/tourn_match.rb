class TournMatch < ActiveRecord::Base
  attr_accessible :created_at, :updated_at, :tourn_user_id, :tourn_deck_id, :tourn_pair_id, :result_id, :coin, :round

  has_many :decks, through: :tourn_decks
  has_many :matches
  belongs_to :tourn_user

  RESULTS_LIST = {
    -1 => 'Undecided',
    0 => 'Draw',
    1 => 'P1 Won',
    2 => 'P2 Won'
  }

  def result_to_s(id)
    RESULTS_LIST[id]
  end

  def user
    tourn_user.user
  end

  def conflict_with_opp?(opp_match)
    (opp_match.result_id + result_id) != 1 && (opp_match.result_id + result_id) != 4
  end
end
