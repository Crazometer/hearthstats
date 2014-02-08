namespace :dbf do
	desc "Add all vars such as mode, result, class and rank"
	task :init=> :environment do
		desc "Import MODES"
    MODES = ["Arena","Casual","Ranked","Friendly","Practice"]
    MODES.each do |m|
      Mode.new(name: m).save
      p m + " mode added."
    end
    p "Modes Module Complete"

    desc "Import RESULTS"
    RESULTS = ["Win", "Loss","Draw"]
    RESULTS.each do |m|
      MatchResult.new(result: m).save
      p m + " result added."
    end

    desc "Import KLASSES"
    KLASSES = ["Druid","Hunter","Mage","Paladin",
               "Priest","Rogue","Shaman","Warlock","Warrior"]
    KLASSES.each do |m|
      Klass.new(name: m).save
      p m + " class added."
    end

    desc "Import RANKS"
    RANKS = ["Innkeeper","The Black Knight","Molten Giant","Moutain Giant",
             "Sea Giatn","Ancient of War","Sunwalker", "Frostwolf Warlord",
             "Silver Hand Knight","Ogre Magi","Big Game Hunter",
             "Warsong Commander","Dread Corsair","Raid Leader",
             "Silvermoon Guardian","Questing Adventurer", "Tauren Warrior",
             "Sorcerer's Apprentice","Novice Engineer","Shieldbearer",
             "Southsea Deckhand", "Murloc Raider","Argent Squire",
             "Leper Gnome","Angry Chicken"]

    RANKS.each do |m|
      Rank.new(name: m).save
      p m + " rank added."
    end
	end

	task :constructed => :environment do
    con_matches = Constructed.all
    i = 0
    con_matches.each do |m|
      next if m.deck.nil?
      klass = Klass.where(name: m.deck.race).first
      oppklass = Klass.where(name: m.oppclass).first
      # Determine if win or loss
      if m.win
        result = 0
      else
        result = 1
      end
      # Determine if ranked or casual
      if m.rank == "Casual"
        mode = 1
      else
        mode = 2
      end

      match = Match.new()
      match.created_at = m.created_at
      match.updated_at = m.updated_at
      match.user_id = m.user_id
      match.class_id = klass.id
      match.oppclass_id = oppklass.id
      match.oppname = m.oppname
      match.mode_id = mode
      match.coin = !m.gofirst
      match.result_id = result
      match.notes = m.notes

      match.save!
      
      MatchDeck.new(
        :deck_id => m.deck_id,
        :match_id => match.id
      ).save!

      i += 1
    end
    p i.to_s + " constructed matches migrated."
	end

	task :arena => :environment do
		arena_matches = Arena.all
    i = 0
		arena_matches.each do |am|
      klass = Klass.where(name: am.userclass).first
      oppklass = Klass.where(name: am.oppclass).first
      # Determine if win or loss
      if am.win
        result = 0
      else
        result = 1
      end
      m = Match.new()
      m.created_at = am.created_at
      m.updated_at = am.updated_at
      m.user_id = am.user_id
      m.class_id = klass.id
      m.oppclass_id = oppklass.id
      m.oppname = am.oppname
      m.coin = !am.gofirst
      m.mode_id = 1
      m.result_id = result
      m.notes = am.notes
      i += 1
		end
    p i.to_s + " arena matches migrated."
	end


end
