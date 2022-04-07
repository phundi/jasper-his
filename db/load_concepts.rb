puts "Loading Concepts"
CSV.foreach("#{Rails.root}/app/assets/data/concepts.csv", :headers => false) do |row|
 next if row[0].blank?
 workflow = Concept.create!(name: row[0].squish)
 puts "Loaded #{workflow.name}"
end
puts "Loaded Modules !!!"
