class WelcomeController < ApplicationController
  def index
  	render :layout=>false
  end

  def novreport

	# Determine Arena Class Win Rates
    classes = ['Druid' ,'Hunter', 'Mage', 'Paladin', 'Priest', 'Rogue', 'Shaman', 'Warlock', 'Warrior']
    @classarenarate = Hash.new
    @arenatot = Hash.new
    classes.each do |c|
      totalwins = 0
      totalgames = 0
      totalwins = Arena.where(:userclass => c, :win => true).count + Arena.where(:oppclass => c, :win => false).count
      totalgames = Arena.where(:userclass => c).count + Arena.where(:oppclass => c).count
      @classarenarate[c] = (totalwins.to_f / totalgames)
      @arenatot[c] = totalgames

    end
    @classarenarate = @classarenarate.sort_by { |name, winsrate| winsrate }.reverse

    # Determine Constructed Class Win Rates

    @classconrate = Hash.new
    @contot = Hash.new
    classes.each do |c|
      totalwins = 0
      totalgames = 0
      totalwins = Constructed.joins(:deck).where(win: true, 'decks.race' => c).count
      totalwins = totalwins + Constructed.joins(:deck).where(oppclass: c, win: false).count
      totalgames = Constructed.joins(:deck).where('decks.race' => c).count + Constructed.joins(:deck).where(oppclass: c).count
      
      @classconrate[c] = (totalwins.to_f / totalgames)
      @contot[c] = totalgames
    end
    @classconrate = @classconrate.sort_by { |name, winsrate| winsrate }.reverse
 	
    # Most Played

    @conclassnum = Hash.new
    classes.each do |a|
    	@conclassnum[a] = @arenatot[a] + @contot[a]
    end

    # Determine Arena Class Win Rates
    classcombos = classes.combination(2).to_a
    @userarenarate = Hash.new
    classcombos.each do |combo|
      totalwins = 0
      totalgames = 0
      totalwins = Arena.where(userclass: combo[0], oppclass: combo[1], win: true).count + Arena.where(userclass: combo[1], oppclass: combo[0], win: false).count
      totalgames = Arena.where(userclass: combo[0], oppclass: combo[1]).count + Arena.where(userclass: combo[1], oppclass: combo[0]).count
      @userarenarate["#{combo[0]} #{combo[1]}"] = (totalwins.to_f / totalgames)
    end

    # Determine Constructed Class Win Rates
    @conrate = Hash.new
    classcombos.each do |combo|
      totalwins = 0
      totalgames = 0

      totalwins = Constructed.joins(:deck).where(oppclass: combo[0], win: true, 'decks.race' => combo[1]).count
      totalwins = totalwins + Constructed.joins(:deck).where(oppclass: combo[1], win: false, 'decks.race' => combo[0]).count

      totalgames = Constructed.joins(:deck).where(oppclass: combo[0], 'decks.race' => combo[1]).count + Constructed.joins(:deck).where(oppclass: combo[1], 'decks.race' => combo[0]).count

      @conrate["#{combo[0]} #{combo[1]}"] = (totalwins.to_f / totalgames)
    end

 	render :layout=> 'fullpage'
  end
end
