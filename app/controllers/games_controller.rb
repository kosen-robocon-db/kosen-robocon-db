class GamesController < ApplicationController
  before_action :logged_in_user,
    only: [ :new, :create, :edit, :update, :destroy ]

  def new
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
        # 短くならないかな？
        # コードがなかったときの処理を加えるべき
    @gt = game_details_sym(@robot.contest_nth) # GameDetail*クラスのシンボル
    if Game.reflect_on_all_associations(:has_many).none? { |i| i.name == @gt }
      # Game クラスに関連付けされていないときだけ GameDeital* クラスを関連付け
      Game.send( :has_many, @gt, foreign_key: :game_code, primary_key: :code,
        dependent: :destroy )
      Game.send( :accepts_nested_attributes_for, @gt, allow_destroy: true,
        reject_if: :all_blank )
    end
    @game = Game.new(robot_code: @robot.code, contest_nth: @robot.contest_nth)
    @game.send(@gt).new # GameDetail* クラスのインスタンス生成
  end

  def create
    @robot = Robot.find_by(code: params[:robot_code])
      # コードがなかったときの処理を加えるべき
    @gt = game_details_sym(@robot.contest_nth) # シンボルの取得
    h = game_params
    h["robot_code"] = @robot.code.to_s
    h["code"] = Game.get_code(h).to_s
    gtas = "#{@gt.to_s}_attributes".to_sym
    klass = @gt.to_s.singularize.classify.constantize # クラス化
    h[gtas].each { |i| h[gtas][i][:properties] = klass.properties(h[gtas][i]) }
      # クラスメソッドによりフォームパラメーターから GameDetail 属性値へ合成
    h[gtas].each { |key, value|
      h[gtas][key] = h[gtas][key].reject { |k, v|
        klass.additional_attr_symbols.any? { |i| i.to_s == k }
          # GameDetailsにないものは削除しておく
      }
    }
    h[:game_details_attributes] = h.delete(gtas) # attributes の名前の変更
    @game = Game.new(h)
    if @game.save then
      flash[:success] = "試合情報の新規作成成功"
      redirect_to robot_url(params[:robot_code])
    else
      render :new
    end
  end

  def edit
    @robot = Robot.find_by(code:
      Rails.application.routes.recognize_path(request.path_info)[:robot_code])
        # 直上のコードは短くならないかな？
        # コードがなかったときの処理を加えるべき
    @gt = game_details_sym(@robot.contest_nth)
    if Game.reflect_on_all_associations(:has_many).none? { |i| i.name == @gt }
      # Game クラスに関連付けされていないときだけ GameDeital* クラスを関連付け
      Game.send( :has_many, @gt, foreign_key: :game_code, primary_key: :code,
        dependent: :destroy )
      Game.send( :accepts_nested_attributes_for, @gt, allow_destroy: true,
        reject_if: :all_blank )
    end
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
    @game.opponent_robot_code = @game.robot_code == @game.left_robot_code ?
      @game.right_robot_code : @game.left_robot_code
    @game.victory = @game.robot_code == @game.winner_robot_code ? "true" : "false"
    @game.send(@gt).each { |i|
      # JSON形式格納文字列から取り出しし、フォーム専用属性に情報をコピー
      hash = JSON.parse(i.properties)
      i.my_height = hash["score"].to_s.split(/-/)[0]
      i.opponent_height = hash["score"].to_s.split(/-/)[1]
    }
  end

  def update
    @robot = Robot.find_by(code: params[:robot_code])
    @gt = game_details_sym(@robot.contest_nth)
    if Game.reflect_on_all_associations(:has_many).none? { |i| i.name == @gt }
      # Game クラスに関連付けされていないときだけ GameDeital* クラスを関連付け
      Game.send( :has_many, @gt, foreign_key: :game_code, primary_key: :code,
        dependent: :destroy )
      Game.send( :accepts_nested_attributes_for, @gt, allow_destroy: true,
        reject_if: :all_blank )
    end
    @game = Game.find_by(code: params[:code])
    @game.robot_code = @robot.code
      # robot_code / code が一致しなかった場合の処理も考えておく
    @gt = game_details_sym(@robot.contest_nth) # シンボルの取得
    h = game_params
    # h["robot_code"] = @robot.code.to_s
    # h["code"] = Game.get_code(h).to_s
    gtas = "#{@gt.to_s}_attributes".to_sym
    klass = @gt.to_s.singularize.classify.constantize # クラス化
    h[gtas].each { |i| h[gtas][i][:properties] = klass.properties(h[gtas][i]) }
      # クラスメソッドによりフォームパラメーターから GameDetail 属性値へ合成
    h[gtas].each { |key, value|
      h[gtas][key] = h[gtas][key].reject { |k, v|
        klass.additional_attr_symbols.any? { |i| i.to_s == k }
          # GameDetailsにないものは削除しておく
      }
    }
    #h[:game_details_attributes] = h.delete(gtas) # attributes の名前の変更
    logger.debug(">>>> h : #{h.to_yaml}")
    # logger.debug(">>>> h[:game_details_attributes] : #{h[:game_details_attributes].to_yaml}")

    if @game.update(h) then
      flash[:success] = "試合情報の編集成功"
      redirect_to robot_url(code: params[:robot_code])
    else
      render :edit
    end
  end

  def destroy
    Game.find_by(code: params[:code]).destroy
    flash[:success] = "試合情報の一つを削除しました。"
    redirect_to robot_path(code: params[:robot_code])
  end

  private
  def game_params
    logger.debug(">>>> game_params : #{params.require(:game).to_yaml}")
    str = "game_detail#{@robot.contest_nth.ordinalize}s"
    a = str.classify.constantize.additional_attr_symbols
    a.push(:id)
    a.push(:_destroy)
    h = {}
    h[str +"_attributes"] = a
    p = [
      :contest_nth, :region_code, :round, :game, :opponent_robot_code, :victory
    ].push(h)
    logger.debug(">>>> p in game_params : #{p.to_yaml}")
    params.require(:game).permit(p)
  end

  def game_details_sym(contest_nth)
    "game_detail#{contest_nth.ordinalize}s".to_sym
  end
end
