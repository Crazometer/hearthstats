require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper
task :NewCards => :environment do

  require 'json'

  file = File.read(Rails.root.join('public', 'uncollectible.json'))

  json = JSON.parse(file)
  rarity = {"Legendary" => 5, "Epic" => 4, "Rare" => 3, "Common" =>2, "Free" => 1}
  counter = 0
  json.each do |q|
    Card.create(
                name: q["name"],
                description: q["text"],
                attack: q["attack"].to_i,
                health: q["health"].to_i,
                mana: q["cost"].to_i,
                rarity_id: rarity[q["rarity"]],
                klass_id: klasses_hash["playerClass"]

               )
    counter += 1
  end
  puts counter.to_s + " Cards Imported"
end
