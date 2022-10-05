class RegionsController < ApplicationController
    require 'date'
    before_action :authenticate_user!

    def show
        @user = current_user
        @regions = Region.where(user_id: @user.id).order("medicin ASC").order("name ASC")
    end

    def new
        @region = Region.new
    end

    def create
        @user = current_user
        @region = @user.regions.create(region_params)
        @region.start = Date.current - 100 #作った日は必ず薬を塗る仕様
        count = 0
        flash[:notice] = region_params
        if region_params[:morning] == "true"
            count += 1
        end
        if region_params[:noon] == "true"
            count += 1
        end
        if region_params[:night] == "true"
            count += 1
        end
        if region_params[:name] == ""
            flash.now[:danger] = "部位名を入力してください"
            render 'new'
        elsif region_params[:interval] == ""
            flash.now[:danger] = "間隔を入力してください"
            render 'new'
        elsif count >= 2 && region_params[:interval] >= 2
            flash.now[:danger] = "間隔を開けて塗布する場合は1日1回のスケジュールにしてください"
            render 'new'
        elsif count == 0
            flash.now[:danger] = "塗る時間帯を選択してください"
            render 'new'
        elsif @region.save
            redirect_to "/regions/show"
            flash[:success] = "新しい部位を登録しました！"
        else
            flash.now[:danger] = "部位登録に失敗しました"
            render 'new'
        end
    end

    def destroy
        if Region.find(params[:id]).destroy
            flash[:success] = "部位を削除しました"
        else
            flash[:danger] = "部位削除に失敗しました"
        end
        redirect_to "/regions/show"
    end

    def edit
        @region = Region.find(params[:id])
    end

    def update
        @region = Region.find(params[:id])
        count = 0
        if region_params[:morning] == "true"
            count += 1
        end
        if region_params[:noon] == "true"
            count += 1
        end
        if region_params[:night] == "true"
            count += 1
        end
        if count >= 2 && region_params[:interval].to_i >= 2
            flash.now[:danger] = "間隔を開けて塗布する場合は1日1回のスケジュールにしてください"
            render 'edit'
        elsif count == 0
            flash.now[:danger] = "塗る時間帯を選択してください"
            render 'edit'
        elsif @region.update(region_params)
            redirect_to "/regions/show"
            flash[:success] = "部位情報を更新しました！"
        else
            flash.now[:danger] = "部位情報のアップデートに失敗しました"
            render 'edit'
        end
    end

    def add_to_top
        @region = Region.find(params[:id])
        @region.update(start:Date.current - 100)
        redirect_to "/regions/show"
    end

    private
    def region_params
        params.require(:region).permit(:name, :interval, :morning, :noon, :night, :medicin)
    end

end
