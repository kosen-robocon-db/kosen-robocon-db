# Dir.glob(File.join(Rails.root, 'db', 'seeds', '*.rb')) do |file|
#  load(file)
# end

load(File.join(Rails.root, 'db', 'seeds', 'region.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'campus.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'contest.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'contest_entry.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'campus_history.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'robot.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'game.rb'))
