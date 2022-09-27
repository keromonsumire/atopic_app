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
        @region.start = Time.current
        if @region.save
            redirect_to "/regions/show"
            flash[:success] = "新しい部位を登録しました！"
        else
            flash[:danger] = "部位登録に失敗しました"
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
        if @region.update(region_params)
            flash[:success] = "部位情報をアップデートしました"
        else
            flash[:danger] = "部位情報のアップデートに失敗しました"
        end
        redirect_to "/regions/show"
    end

    def add_to_top
        @region = Region.find(params[:id])
        if Time.current.strftime("%H").to_i > 3
            @region.update(start: Date.current)
        else
            @region.update(start: Date.yesterday)
        end
        redirect_to "/regions/show"
    end

    private
    def region_params
        params.require(:region).permit(:name, :interval, :morning, :noon, :night, :medicin)
    end
end
