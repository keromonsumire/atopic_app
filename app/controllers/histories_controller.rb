class HistoriesController < ApplicationController
    require 'date'
    before_action :authenticate_user!
    def show
        if session[:month] == nil
            month_in_display = Date.today
        else
            month_in_display = Date.today >> session[:month]
        end  
        days = month_in_display.end_of_month.day
        month = month_in_display.month
        @dates = []
        (1..days).each do |day|
            @dates.push("#{month}/#{day}")
        end
        @regions = Region.where(user_id: current_user.id).order("medicin ASC")
        @histories = []
        @regions.each do |region|
            colors = []
            colors.push(region.name)
            days.times do |day|
                count = History.where(region_id: region.id, date: month_in_display.beginning_of_month + day.day).count
                if count == 0
                    colors.push("colorless")
                elsif count == 1
                    colors.push("light-skyblue")
                elsif count == 2
                    colors.push("dark-skyblue")
                elsif count >= 3
                    colors.push("blue")
                end
            end
            @histories.push(colors)
        end
    end

    def create_morning
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current - region.start).to_i % region.interval == 0 
                if region.morning && !History.exists?(region_id:region.id, date:Date.current, is_yesterday:true)
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Date.current, time: "morning"})
        end
        redirect_to root_path
    end

    def create_noon
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current - region.start).to_i % region.interval == 0 
                if region.noon
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Date.current, time: "noon"})
        end
        redirect_to root_path
    end

    def create_night
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current - region.start).to_i % region.interval == 0 
                if region.night
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Date.current, time: "night"})
        end
        redirect_to root_path
    end
    
    def create_yesterday_night
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if region.interval == 1 || (Date.current.yesterday - region.start).to_i % region.interval == 0 
                if region.night
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Date.current, time: "morning", is_yesterday: true})
        end
        redirect_to root_path
    end

    def next_month
        if session[:month] == nil
            session[:month] = 0
        end
        session[:month] += 1
        redirect_to "/histories/show"
    end

    def prev_month
        if session[:month] == nil
            session[:month] = 0
        end
        session[:month] -= 1
        redirect_to "/histories/show"
    end
end
