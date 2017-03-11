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
