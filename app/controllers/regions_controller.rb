class RegionsController < ApplicationController
    before_action :authenticate_user!

    def show
        @user = current_user
        @regions = Region.where(user_id: @user.id)
    end

    def new
        @region = Region.new
    end

    def create
        @user = current_user
        @region = @user.regions.create(params.require(:region).permit(:name, :interval, :morning, :noon, :night))
        @region.start = Time.current
        if @region.save
            redirect_to "/regions/show"
            flash[:success] = "新しい部位を登録しました！"
        else
            flash[:notice] = "部位登録に失敗しました"
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
        if @region.update(params.require(:region).permit(:name, :interval, :morning, :noon, :night))
            flash[:success] = "部位情報をアップデートしました"
        else
            flash[:danger] = "部位情報のアップデートに失敗しました"
        end
        redirect_to "/regions/show"
    end
end
