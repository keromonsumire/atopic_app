class RegionsController < ApplicationController
    before_action :authenticate_user!

    def show
        @regions = Region.all
    end

    def new
        @region = Region.new
    end

    def create
        @user = current_user
        @region = @user.regions.create(params.require(:region).permit(:name, :interval, :time))
        if @region
            redirect_to "/regions/show"
            flash[:success] = "新しい部位を登録しました！"
        else
            flash[:notice] = "部位登録に失敗しました"
            render 'new'
        end
    end
end
