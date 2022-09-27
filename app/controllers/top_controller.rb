class TopController < ApplicationController
    require 'date'
    def index
        if user_signed_in?
            @user = current_user
            @regions = Region.where(user_id: @user.id).order("medicin ASC").order("name ASC")
            @regions_today_morning = []
            @regions_today_noon = []
            @regions_today_night = []
            @regions_yesterday_night = []
            @check_morning = false
            @check_noon = false
            @check_night = false
            @check_yesterday_night = false
            @check_now_morning = false
            @check_now_midnight = false
            if Time.current.strftime("%H").to_i > 3
                @check_now_midnight = true
                if @regions
                    @regions.each do |region|
                        if region.interval == 1 || (Date.current - region.start).to_i % region.interval == 0 
                            if region.morning && !History.exists?(region_id:region.id, date:Date.current, is_yesterday:true)
                                @regions_today_morning.push(region)
                            end
                            if region.noon
                                @regions_today_noon.push(region)
                            end
                            if region.night
                                @regions_today_night.push(region)
                            end
                        end
                        if region.interval == 1 || (Date.current.yesterday - region.start).to_i % region.interval == 0 
                            if region.night
                                @regions_yesterday_night.push(region)
                            end
                        end
                    end   

                    @regions.each do |region|
                        if History.exists?(region_id: region.id, time: "morning", date: Date.current, is_yesterday:false)
                            @check_morning = true
                        end    
                        if History.exists?(region_id: region.id, time: "noon", date: Date.current)
                            @check_noon = true
                        end    
                        if History.exists?(region_id: region.id, time: "night", date: Date.current)
                            @check_night = true
                        end    
                        if History.exists?(region_id: region.id, time: "morning", date: Date.current, is_yesterday: true) || History.exists?(region_id: region.id, time: "night", date: Date.current.yesterday)
                            @check_yesterday_night = true
                        end   
                        if @check_morning && @check_noon && @check_night && @check_yesterday_night
                            break
                        end 
                    end
                end    

            elsif @regions
                @regions.each do |region|
                    if region.interval == 1 || (Date.current.yesterday - region.start).to_i % region.interval == 0 
                        if region.morning && !History.exists?(region_id:region.id, date:Date.current - 2, is_yesterday:true)
                            @regions_today_morning.push(region)
                        end
                        if region.noon
                            @regions_today_noon.push(region)
                        end
                        if region.night
                            @regions_today_night.push(region)
                        end
                    end
                    if region.interval == 1 || (Date.current - 2 - region.start).to_i % region.interval == 0 
                        if region.night
                            @regions_yesterday_night.push(region)
                        end
                    end
                end   
                @regions.each do |region|
                    if History.exists?(region_id: region.id, time: "morning", date: Date.current.yesterday, is_yesterday:false)
                        @check_morning = true
                    end    
                    if History.exists?(region_id: region.id, time: "noon", date: Date.current.yesterday)
                        @check_noon = true
                    end    
                    if History.exists?(region_id: region.id, time: "night", date: Date.current.yesterday)
                        @check_night = true
                    end    
                    if History.exists?(region_id: region.id, time: "morning", date: Date.current.yesterday, is_yesterday: true) || History.exists?(region_id: region.id, time: "night", date: Date.current - 2)
                        @check_yesterday_night = true
                    end   
                    if @check_morning && @check_noon && @check_night && @check_yesterday_night
                        break
                    end 
                end
            end
            
            if 3 < Time.current.strftime("%H").to_i && Time.current.strftime("%H").to_i < 12
                @check_now_morning = true
            end

        else
            @user = nil
        end
    end
end
