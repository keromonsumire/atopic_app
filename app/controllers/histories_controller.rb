class HistoriesController < ApplicationController
    require 'date'
    before_action :authenticate_user!
    before_action :setup, only: [:create_morning, :create_noon, :create_night, :create_yesterday_night]

    def setup
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
    end

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
        @regions = Region.where(user_id: current_user.id).order("interval ASC").order("name ASC")
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
        if Time.current.strftime("%H").to_i > 3
            @regions.each do |region|
                if (Date.current - region.start).to_i >= region.interval
                    if region.morning && !History.exists?(region_id:region.id, date:Date.current, is_yesterday:true)
                        @regions_create.push(region)
                    end
                end
            end
            @regions_create.each do |region|
                region.histories.create({date: Date.current, time: "morning"})
                region.update(start:Date.current)
            end
        else
            @regions.each do |region|
                if (Date.current.yesterday - region.start).to_i >= region.interval
                    if region.morning && !History.exists?(region_id:region.id, date:Date.current.yesterday, is_yesterday:true)
                        @regions_create.push(region)
                    end
                end
            end
            @regions_create.each do |region|
                region.histories.create({date: Date.current.yesterday, time: "morning"})
                region.update(start:Date.current.yesterday)
            end
        end
        redirect_to root_path
    end

    def create_noon
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        if Time.current.strftime("%H").to_i > 3
            @regions.each do |region|
                if (Date.current - region.start).to_i >= region.interval 
                    if region.noon
                        @regions_create.push(region)
                    end
                end
            end
            @regions_create.each do |region|
                region.histories.create({date: Date.current, time: "noon"})
                region.update(start:Date.current)
            end
        else
            @regions.each do |region|
                if (Date.current.yesterday - region.start).to_i >= region.interval 
                    if region.noon 
                        @regions_create.push(region)
                    end
                end
            end
            @regions_create.each do |region|
                region.histories.create({date: Date.current.yesterday, time: "noon"})
                region.update(start:Date.current.yesterday)
            end
        end
        redirect_to root_path
    end

    def create_night
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        if Time.current.strftime("%H").to_i > 3
            @regions.each do |region|
                if (Date.current - region.start).to_i >= region.interval
                    if region.night
                        @regions_create.push(region)
                    end
                end
            end
            @regions_create.each do |region|
                region.histories.create({date: Date.current, time: "night"})
                region.update(start:Date.current)
            end
        else
            @regions.each do |region|
                if (Date.current.yesterday - region.start).to_i >= region.interval 
                    if region.night 
                        @regions_create.push(region)
                    end
                end
            end
            @regions_create.each do |region|
                region.histories.create({date: Date.current.yesterday, time: "night"})
                region.update(start:Date.current.yesterday)
            end
        end
        redirect_to root_path
    end
    
    def create_yesterday_night
        @user = current_user  
        @regions = Region.where(user_id: @user.id)
        @regions_create = []
        @regions.each do |region|
            if (Date.current.yesterday - region.start).to_i >= region.interval 
                if region.night
                    @regions_create.push(region)
                end
            end
        end
        @regions_create.each do |region|
            region.histories.create({date: Date.current, time: "morning", is_yesterday: true})
            region.update(start:Date.current)
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
