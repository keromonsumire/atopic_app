class TopController < ApplicationController
    require 'date'
    def index
        if user_signed_in?
            @user = current_user
            @regions = Region.where(user_id: @user.id)
            @regions_today_morning = []
            @regions_today_night = []
            @regions.each do |region|
                if (Date.current - region.start).to_i == 0 || (Date.current - region.start).to_i % (region.interval - 1) == 0 
                    if region.time == "morning" || region.time == "both"
                        @regions_today_morning.push(region)
                    end
                    if region.time == "night" || region.time == "both"
                        @regions_today_night.push(region)
                    end
                end
            end
        else
            @user = nil
        end
    end
end
