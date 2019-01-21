# 将来的に下記のように関数を使うように置き換える。
# class Bulk
#   def initialize
#     @bulk_insert_data = []
#   end  
#   def insert(nth, region, round, name)
#     @bulk_insert_data << RoundName.new(contest_nth: nth, region_code: region, round: round, name: name)
#   end
#   def import
#     # エキシビジョ追加
#     # ソート
#     RoundName.import bulk_insert_data
#   end
#   private
#   def エキシビジョン追加
#   end
#   def ソート
#   end
# end
# bulk = Bulk.new
# bulk.insert(1, 0, 0, "予選")
# bulk.insert(1, 0, 1, "準決勝")
# bulk.insert(1, 0, 2, "決勝")
# #...
# bulk.imort

bulk_insert_data = []

################################################################################
# 1988 1st
bulk_insert_data << RoundName.new(contest_nth: 1, region_code: 0, round: 0, name: "予選")
bulk_insert_data << RoundName.new(contest_nth: 1, region_code: 0, round: 1, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 1, region_code: 0, round: 2, name: "決勝")

################################################################################
# 1989 2nd
bulk_insert_data << RoundName.new(contest_nth: 2, region_code: 0, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 2, region_code: 0, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 2, region_code: 0, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 2, region_code: 0, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 2, region_code: 0, round: 5, name: "決勝")

################################################################################
# 1990 3rd
bulk_insert_data << RoundName.new(contest_nth: 3, region_code: 0, round: 0, name: "予選")
bulk_insert_data << RoundName.new(contest_nth: 3, region_code: 0, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 3, region_code: 0, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 3, region_code: 0, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 3, region_code: 0, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 3, region_code: 0, round: 5, name: "決勝")

################################################################################
# 1991 4th to 2003 16th
for nth in 4..16 do
  # 全国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 5, name: "決勝")
  # 北海道
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 4, name: "決勝")
  # 東北
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 4, name: "決勝")
  # 関東甲信越
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 5, name: "決勝")
  # 東海北陸
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 5, name: "決勝")
  # 近畿
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 4, name: "決勝")
  # 中国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 4, name: "決勝")
  # 四国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 4, name: "決勝")
  # 九州沖縄
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 5, name: "決勝")

end

################################################################################
# 2004 17th to 2005 18th
# see:2004 17th, https://web.archive.org/web/20051228072817/http://www.official-robocon.com:80/jp/kosen/kosen2004/result/zenkoku.html
# see:2005 18th, https://web.archive.org/web/20160710185324/http://www.official-robocon.com:80/jp/kosen/kosen2005/result_zenkoku.html
for nth in 17..18 do
  # 全国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 4, name: "４回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 5, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 6, name: "決勝")
  # 北海道
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 4, name: "決勝")
  # 東北
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 4, name: "決勝")
  # 関東甲信越
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 5, name: "決勝")
  # 東海北陸
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 5, name: "決勝")
  # 近畿
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 4, name: "決勝")
  # 中国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 4, name: "決勝")
  # 四国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 4, name: "決勝")
  # 九州沖縄
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 5, name: "決勝")
end

################################################################################
# 2006 19th
# see: https://web.archive.org/web/20160412100511/http://official-robocon.com/jp/kosen/kosen2006/result_zenkoku.html
# 全国
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 0, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 0, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 0, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 0, round: 4, name: "４回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 0, round: 5, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 0, round: 6, name: "決勝")
# 北海道
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 1, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 1, round: 2, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 1, round: 3, name: "決勝")
# 東北
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 2, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 2, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 2, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 2, round: 4, name: "決勝")
# 関東甲信越
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 3, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 3, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 3, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 3, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 3, round: 5, name: "決勝")
# 東海北陸
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 4, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 4, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 4, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 4, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 4, round: 5, name: "決勝")
# 近畿
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 5, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 5, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 5, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 5, round: 4, name: "決勝")
# 中国
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 6, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 6, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 6, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 6, round: 4, name: "決勝")
# 四国
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 7, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 7, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 7, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 7, round: 4, name: "決勝")
# 九州沖縄
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 8, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 8, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 8, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 8, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 19, region_code: 8, round: 5, name: "決勝")

################################################################################
# 2007 20th
# see: https://web.archive.org/web/20160306195834/http://official-robocon.com/jp/kosen/kosen2007/result_zenkoku.html
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 0, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 0, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 0, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 0, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 0, round: 5, name: "決勝")
# 北海道
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 1, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 1, round: 2, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 1, round: 3, name: "決勝")
# 東北
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 2, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 2, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 2, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 2, round: 4, name: "決勝")
# 関東甲信越
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 3, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 3, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 3, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 3, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 3, round: 5, name: "決勝")
# 東海北陸
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 4, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 4, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 4, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 4, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 4, round: 5, name: "決勝")
# 近畿
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 5, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 5, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 5, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 5, round: 4, name: "決勝")
# 中国
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 6, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 6, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 6, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 6, round: 4, name: "決勝")
# 四国
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 7, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 7, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 7, round: 3, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 7, round: 4, name: "決勝")
# 九州沖縄
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 8, round: 1, name: "1回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 8, round: 2, name: "2回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 8, round: 3, name: "3回戦")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 8, round: 4, name: "準決勝")
bulk_insert_data << RoundName.new(contest_nth: 20, region_code: 8, round: 5, name: "決勝")

################################################################################
# 2008 21th to 2009 22th
# 今後全極で予選が行われた場合、例えば第35回大会の地区予選がこれまでと同じであれば、
# 次のようにするとよい。
# for nth in [21,22,35] do
for nth in 21..22 do
  # 全国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 0, name: "予選")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 2, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 3, name: "決勝")
  # 北海道
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 2, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 3, name: "決勝")
  # 東北
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 4, name: "決勝")
  # 関東甲信越
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 5, name: "決勝")
  # 東海北陸
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 5, name: "決勝")
  # 近畿
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 4, name: "決勝")
  # 中国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 4, name: "決勝")
  # 四国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 4, name: "決勝")
  # 九州沖縄
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 5, name: "決勝")
end

################################################################################
# 2010 23th to 2017 30th
for nth in 23..30 do
  # 全国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 5, name: "決勝")
  # 北海道
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 2, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 1, round: 3, name: "決勝")
  # 東北
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 2, round: 4, name: "決勝")
  # 関東甲信越
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 3, round: 5, name: "決勝")
  # 東海北陸
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 4, round: 5, name: "決勝")
  # 近畿
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 5, round: 4, name: "決勝")
  # 中国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 6, round: 4, name: "決勝")
  # 四国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 3, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 7, round: 4, name: "決勝")
  # 九州沖縄
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 8, round: 5, name: "決勝")
end

################################################################################
# 2018 31th to 2018 31th
for nth in 31..31 do
  # 全国
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 1, name: "1回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 2, name: "2回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 3, name: "3回戦")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 4, name: "準決勝")
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0, round: 5, name: "決勝")
  # 北海道、東北、関東甲信越、東海北陸、近畿、中国、四国、九州沖縄
  for region in 1..8 do
    bulk_insert_data << RoundName.new(contest_nth: nth, region_code: region, round: 0, name: "予選")
    bulk_insert_data << RoundName.new(contest_nth: nth, region_code: region, round: 1, name: "準決勝")
    bulk_insert_data << RoundName.new(contest_nth: nth, region_code: region, round: 2, name: "決勝")
  end
end


# 各回、全国および各地区にエキシビジョンを追加
for nth in 1..3 do
  bulk_insert_data << RoundName.new(contest_nth: nth, region_code: 0,
    round: 9, name: "エキシビジョン")
end
for nth in 4..31 do
  for region in 0..8 do
    bulk_insert_data << RoundName.new(contest_nth: nth, region_code: region,
      round: 9, name: "エキシビジョン")
  end
end

# 昇順ソートしておく
bulk_insert_data.sort_by! { | b | [ b.contest_nth, b.region_code, b.round ] }

RoundName.import bulk_insert_data
