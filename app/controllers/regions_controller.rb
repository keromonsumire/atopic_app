class RegionsController < ApplicationController
  require 'date'
  before_action :authenticate_user!
  before_action :correct_user, only: %i[destroy edit update add_to_top ]

  def index
    @user = current_user
    @regions = Region.where(user_id: @user.id).order('interval ASC').order('medicin ASC')
  end

  def new
    @region = Region.new
  end

  def create
    @user = current_user
    @region = @user.regions.create(region_params)
    @region.last_morning = Date.current - 100 # 作った日は必ず薬を塗る仕様
    @region.last_noon = Date.current - 100
    @region.last_night = Date.current - 100
    count = 0
    count += 1 if region_params[:morning] == 'true'
    count += 1 if region_params[:noon] == 'true'
    count += 1 if region_params[:night] == 'true'
    if region_params[:name] == ''
      flash.now[:danger] = '部位名を入力してください'
      render 'new'
    elsif region_params[:interval] == ''
      flash.now[:danger] = '間隔を入力してください'
      render 'new'
    elsif count >= 2 && region_params[:interval].to_i >= 2
      flash.now[:danger] = '間隔を開けて塗布する場合は1日1回のスケジュールにしてください'
      render 'new'
    elsif count == 0
      flash.now[:danger] = '塗る時間帯を選択してください'
      render 'new'
    elsif @region.save
      redirect_to regions_path
      flash[:success] = '新しい部位を登録しました！'
    else
      flash.now[:danger] = '部位登録に失敗しました'
      render 'new'
    end
  end

  def destroy
    if Region.find(params[:id]).destroy
      flash[:success] = '部位を削除しました'
    else
      flash[:danger] = '部位削除に失敗しました'
    end
    redirect_to regions_path
  end

  def edit
    @region = Region.find(params[:id])
  end

  def update
    @region = Region.find(params[:id])
    count = 0
    count += 1 if region_params[:morning] == 'true'
    count += 1 if region_params[:noon] == 'true'
    count += 1 if region_params[:night] == 'true'
    if count >= 2 && region_params[:interval].to_i >= 2
      flash.now[:danger] = '間隔を開けて塗布する場合は1日1回のスケジュールにしてください'
      render 'edit'
    elsif count == 0
      flash.now[:danger] = '塗る時間帯を選択してください'
      render 'edit'
    elsif @region.update(region_params)
      redirect_to regions_path
      flash[:success] = '部位情報を更新しました！'
    else
      flash.now[:danger] = '部位情報のアップデートに失敗しました'
      render 'edit'
    end
  end

  def add_interval
    regions = Region.where(user_id:current_user.id)
    regions.each do |region|
      if region.morning == true && region.noon == true && region.night == true 
        region.update(noon:false)
      elsif region.morning == true && region.night == true
        region.update(morning:false)
      elsif region.morning == true && region.noon == true 
        region.update(noon:false)
      elsif region.noon == true && region.night == true
        region.update(noon:false)
      elsif region.interval < 7
        region.increment!(:interval, 1)
      end        
    end
    flash[:success] = '間隔を増加させました!'
    redirect_to regions_path
  end

  
  private

  def region_params
    params.require(:region).permit(:name, :interval, :morning, :noon, :night, :medicin)
  end

  def correct_user
    region = Region.find(params[:id])
    if current_user.id != region.user_id
      redirect_to root_path
      flash[:danger] = '権限がありません'
    end
  end
end
