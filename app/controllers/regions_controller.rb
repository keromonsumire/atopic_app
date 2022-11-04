class RegionsController < ApplicationController
  require 'date'
  before_action :authenticate_user!
  before_action :correct_user, only: %i[destroy edit update add_to_top ]

  def index
    @user = current_user
    @regions = Region.where(user_id: @user.id).order('interval ASC').order('medicin ASC')
  end

  def new
    @region = Region.new(session[:region] || {})
  end

  def new_reenter(msg)
    session[:region] = @region.attributes.slice(*region_params.keys)
    redirect_to new_region_path
    flash[:danger] = msg
  end

  def edit_reenter(msg)
    redirect_to edit_region_path
    flash[:danger] = msg
  end

  def create
    @user = current_user
    @region = @user.regions.new(region_params)
    @region.last_morning = Date.current - 100 # 作った日は必ず薬を塗る仕様
    @region.last_noon = Date.current - 100
    @region.last_night = Date.current - 100
    @region.proactive_start = Date.current if region_params[:is_proactive] == 'true'
    if region_params[:is_proactive] == 'true' && region_params[:proactive_interval] == ''
      new_reenter('プロアクティブ間隔を入力してください')
    else
      count = 0
      count += 1 if region_params[:morning] == 'true'
      count += 1 if region_params[:noon] == 'true'
      count += 1 if region_params[:night] == 'true'
      if region_params[:name] == ''
        new_reenter('部位名を入力してください')
      elsif region_params[:interval] == ''
        new_reenter('間隔を入力してください')
      elsif count >= 2 && region_params[:interval].to_i >= 2
        new_reenter('間隔を開けて塗布する場合は1日1回のスケジュールにしてください')
      elsif count == 0
        new_reenter('塗る時間帯を選択してください')
      elsif @region.save
        session.delete(:region) if session[:region]
        redirect_to regions_path
        flash[:success] = '新しい部位を登録しました！'
      else
        new_reenter('部位登録に失敗しました')
      end
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
    @proactive_check = @region.is_proactive
    if region_params[:is_proactive] == 'true' && region_params[:proactive_interval] == ''
      edit_reenter('プロアクティブ間隔を入力してください')
    else
      count = 0
      count += 1 if region_params[:morning] == 'true'
      count += 1 if region_params[:noon] == 'true'
      count += 1 if region_params[:night] == 'true'
      if count >= 2 && region_params[:interval].to_i >= 2
        edit_reenter('間隔を開けて塗布する場合は1日1回のスケジュールにしてください')
      elsif count == 0
        edit_reenter('塗る時間帯を選択してください')
      elsif @region.update(region_params)
        @region.update(proactive_start:Date.current) if region_params[:is_proactive] == 'true' && !@proactive_check
        redirect_to regions_path
        flash[:success] = '部位情報を更新しました！'
      else
        edit_reenter('部位情報のアップデートに失敗しました')
      end
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
    params.require(:region).permit(:name, :interval, :morning, :noon, :night, :medicin, :is_proactive, :proactive_interval)
  end

  def correct_user
    region = Region.find(params[:id])
    if current_user.id != region.user_id
      redirect_to root_path
      flash[:danger] = '権限がありません'
    end
  end
end
