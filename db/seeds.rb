# seedの前にDBの内容を空にする(順不同のはずだが念のためloadの逆順で与える)
RobotCondition.delete_all
PrizeHistory.delete_all
Prize.delete_all
GameDetails.delete_all
Game.delete_all
Robot.delete_all
CampusHistory.delete_all
ContestEntry.delete_all
Contest.delete_all
Campus.delete_all
Region.delete_all

# ファイル名の先頭で読み込み順を与える場合には
# db/seedsディレクトリ中のファイルをグロービングさせるコードを利用。
# ファイル例：01_region.rb, 02_campus.rb, 03_contest.rb, ...
# Dir.glob(File.join(Rails.root, 'db', 'seeds', '*.rb')) do |file|
#  load(file)
# end

# load()の実行順でデータベース初期データを与える場合には以下のコードを利用
load(File.join(Rails.root, 'db', 'seeds', 'region.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'campus.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'contest.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'contest_entry.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'campus_history.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'robot.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'game.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'game_details.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'prize.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'prize_history.rb'))
load(File.join(Rails.root, 'db', 'seeds', 'robot_condition.rb'))
