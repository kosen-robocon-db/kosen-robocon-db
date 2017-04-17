class UsersController < ApplicationController
  before_action :admin_user, only: [:index, :destroy, :approve, :unapprove]

  def index
    @users = User.order_default.on_page(params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    name = @user.nickname
    @user.destroy
    flash[:success] = "ユーザー：@#{name} を削除しました。"
    if @user.mcre?
      redirect_to root_path
    else
      redirect_to users_path
    end
  end

  def approve
    user = User.find(params[:id])
    user.approved = true
    if user.save
      flash[:success] = "ユーザー：@#{user.nickname} を承認しました。"
    end
    redirect_to users_path
  end

  def unapprove
    user = User.find(params[:id])
    user.approved = false
    if user.save
      flash[:success] = "ユーザー：@#{user.nickname} の承認を取り消しました。"
    end
    redirect_to users_path
  end

end
