class GamesController < ApplicationController

  before_action :logged_in_user,
    only: [ :new, :create, :edit, :update, :destroy ]
  before_action :admin_user, only: :index

  def show
    # 試合コードは"1300901"のような1で始まり、2-3桁目が大会回数となっているが、
    # 疑いもなく、エラー処理もRailsデフォルト任せにしておく。（暫定）
    @gd_sym = game_details_sub_class_sym(contest_nth: params[:code][1, 2].to_i)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.subjective_view_by(robot_code: @game.left_robot_code)
    @game.send(@gd_sym).each do |i|
      i.decompose_properties(robot: @game.left_robot)
    end
  end

  def new
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.new(robot_code: @robot.code, contest_nth: @robot.contest_nth)
    # case @robot.contest_nth
    # when 1..20,29,30 then
      @game.send(@gd_sym).new # GameDetail サブクラスのインスタンス生成
    # end
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: 0)
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    h = regularize(attrs_hash: game_params)
    h["robot_code"] = @robot.code.to_s
    h["code"] = Game.get_code(hash: h).to_s
    @game = Game.new(h)
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: @game.region_code)
    if @game.save then
      flash[:success] = "試合情報の新規作成成功"
      redirect_to robot_url(params[:robot_code])
    else
      error_with_code?(code: h["code"])
      render :new
    end
  end

  def edit
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.subjective_view_by(robot_code: @robot.code)
    @game.send(@gd_sym).each { |i| i.decompose_properties(robot: @robot) }
    gon.contest_nth = @robot.contest_nth
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: @game.region_code)
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @gd_sym = game_details_sub_class_sym(contest_nth: @robot.contest_nth)
    Game.confirm_or_associate(game_details_sub_class_sym: @gd_sym)
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    @regions = Region.where(code: [ 0, @robot.campus.region_code ])
    @round_names = RoundName.where(contest_nth: @robot.contest_nth,
      region_code: @game.region_code)
    h = regularize(attrs_hash: game_params)
    # 下記のコードはもっと洗練されるべき
    if @game.region_code.to_i != h['region_code'].to_i or
      @game.round.to_i != h['round'].to_i or
      @game.game.to_i != h['game'].to_i then
      # game_code の変更がある場合
      h["robot_code"] = @robot.code.to_s
      h["code"] = Game.get_code(hash: h).to_s
      old_game_code = @game.code
      gdas = "#{@gd_sym.to_s}_attributes".to_sym
      h[gdas].each{ |i| # id を nil にしないと新しいレコードが登録されない
        h[gdas][i][:id] = nil
      }
      @game = Game.new(h)
      if @game.save then
        Game.find_by(code: old_game_code).destroy
        flash[:success] = "試合情報の編集成功"
        redirect_to robot_url(code: params[:robot_code])
      else
        error_with_code?(code: h["code"])
        render :edit
      end
    else
      # game_code の変更がない場合
      if @game.update(h) then
        flash[:success] = "試合情報の編集成功"
        redirect_to robot_url(code: params[:robot_code])
      else
        error_with_code?(code: h["code"])
        render :edit
      end
    end

  end

  def destroy
    Game.find_by(code: params[:code]).destroy
    flash[:success] = "試合情報の一つを削除しました。"
    redirect_to robot_path(code: params[:robot_code])
  end

  private

  def game_params
    h = { "#{@gd_sym.to_s}_attributes" =>
      @gd_sym.to_s.classify.constantize.attr_syms_for_params }
    a = [
      :contest_nth, :region_code, :round, :game, :opponent_robot_code, :victory,
      { :reasons_for_victory => [] }
    ].push(h)
    params.require(:game).permit(a)
  end

  def regularize(attrs_hash:)
    gdas = "#{@gd_sym.to_s}_attributes".to_sym
    klass = @gd_sym.to_s.singularize.classify.constantize # クラス化
    j = 1
    if not attrs_hash[gdas].blank?
      attrs_hash[gdas].each { |i|
        attrs_hash[gdas][i][:my_robot_code]  = @robot.code.to_s
        attrs_hash[gdas][i][:opponent_robot_code] =
          attrs_hash[:opponent_robot_code]
        attrs_hash[gdas][i][:victory] = attrs_hash[:victory]
        attrs_hash[gdas][i][:properties] =
          klass.compose_properties(hash: attrs_hash[gdas][i]).to_json
            # フォームパラメーターから GameDetail サブクラスの properties を合成
            # before...でできないのかな？
        attrs_hash[gdas][i][:number] = j
        j += 1
      }
    end
    attrs_hash
  end

  def game_details_sub_class_sym(contest_nth:)
    "game_detail#{contest_nth.ordinalize}s".to_sym
  end

  def error_with_code?(code: code)
    # メッセージは表示せず、エラー箇所だけそれを示すタグを差し込みたいが、
    # 今のところはメッセージ表示をしておくことにした。
    # 方法が分かり次第改善する。
    # takenかどうかまで判別したほうがよい？
    if @game.errors.include?(:code)
      @game.errors[:code].map!{ |i|
        i << "（#{view_context.link_to "該当試合", game_path(code)}）"
      }
      @game.errors.add(:region_code, "")
      @game.errors.add(:round, "")
      @game.errors.add(:game, "")
    end
  end

end
