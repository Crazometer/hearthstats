class Deck < ActiveRecord::Base
  attr_accessible :loses, :name, :wins, :race, :decklink, :notes, :cardstring, :klass_id
  has_many :constructeds

  belongs_to :klass
  has_many :matches, :through => :match_deck
  has_many :match_deck
  
  has_many :cards, :through => :deck_card
  has_many :deck_card

  before_save :validate_and_update_stats

  after_destroy :delete_all_constructed

  is_impressionable

  extend FriendlyId
  friendly_id :name, use: :slugged

  def delete_all_constructed
  	Constructed.destroy_all(:deck_id => self.id)
  end
  
  def validate_and_update_stats
    
    #update cards from cardstring
    
    
  	#self.is_valid = true
  end

  def decklink_message

    # Add http:// to link if not present
    # If page is not a valid link then return link
    # Else return list of cards in deck
    # If Nokogiri fails to parse, return No deck link if blank
    # Else return link
    if !decklink.present?
      message = "No deck link attatched to this deck yet <p>"
    else
    	link = prepend_http(decklink)
	    begin
	      page = Nokogiri::HTML(open(link))
	      if !page.css('header').text.blank?
	        message = "<a href='#{link}'>Link To Deck</a><p>"
	      else
	        message = page.text
	      end
	    rescue
        link = link[0..-10]
        message = "<a href='#{link}'>Link To Deck</a><p>"
      end
    end

    message
  end

  def self.bestuserdeck(userid)
		decks = Deck.where(user_id: userid)
		winrates = Hash.new
		decks.each do |d|
			if d.constructeds.count == 0
			else
				winrates[d.name] = [((d.constructeds.where(win:true).count.to_f / d.constructeds.count)*100).round, d.id]
			end
		end
		deck = winrates.max_by { |x,y| y}
		deck
  end
  
  def class_name
    if klass.nil?
      return race
    end
    return klass.name
  end
  
  def num_matches
    return matches.count
  end
  
  def wins
    return matches.where(result_id: 1).count
  end
  
  def losses
    return matches.where(result_id: 2).count
  end
  
  def winrate
    return num_matches > 0 ? (wins.to_f / num_matches) * 100 : 0
  end

  def self.race_count
    races = Deck.pluck(:race)
    race_groups = races.group_by { |race| race } # {"Druid" => ["Druid", "Druid"]}

    Hash[race_groups.map { |race, list| [race, list.size] }]
  end
  
  

  private

  def prepend_http(url)
    url = "http://" + url if URI.parse(url).scheme.nil?

    url
  end
end
