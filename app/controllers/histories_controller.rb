class HistoriesController < ApplicationController
    before_action :authenticate_user!
    def show
        @histories = History.all
    end

    def create_morning
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current - region.start).to_i % (region.interval - 1) == 0 
                if region.morning
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Time.current, time: "morning"})
        end
        redirect_to root_path
    end

    def create_noon
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current - region.start).to_i % (region.interval - 1) == 0 
                if region.noon
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Time.current, time: "noon"})
        end
        redirect_to root_path
    end

    def create_night
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current - region.start).to_i % (region.interval - 1) == 0 
                if region.night
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Time.current, time: "night"})
        end
        redirect_to root_path
    end
    
end
