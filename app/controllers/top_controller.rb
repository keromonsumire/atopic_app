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
            if Time.current.strftime("%H").to_i > 3 #深夜4時以降の処理
                if @regions
                    @regions.each do |region| 
                        if ((Date.current - region.last_morning).to_i >= region.interval) && region.morning && !History.exists?(region_id:region.id, date:Date.current, is_yesterday:true)
                            @regions_today_morning.push(region)
                        end
                        if ((Date.current - region.last_noon).to_i >= region.interval) && region.noon
                            @regions_today_noon.push(region)
                        end
                        if ((Date.current - region.last_night).to_i >= region.interval) && region.night
                            @regions_today_night.push(region)
                        end
                        if (Date.current.yesterday - region.last_night).to_i >= region.interval 
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

            elsif @regions #深夜0時から3時59分までの処理
                @regions.each do |region| 
                    if ((Date.current.yesterday - region.last_morning).to_i >= region.interval) && region.morning && !History.exists?(region_id:region.id, date:Date.current.yesterday, is_yesterday:true)
                        @regions_today_morning.push(region)
                    end
                    if ((Date.current.yesterday - region.last_noon).to_i >= region.interval) && region.noon
                        @regions_today_noon.push(region)
                    end
                    if ((Date.current.yesterday - region.last_night).to_i >= region.interval) && region.night
                        @regions_today_night.push(region)
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
