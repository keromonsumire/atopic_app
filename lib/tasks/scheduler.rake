require 'date'
namespace :scheduler do
    desc "This task is called by the Heroku scheduler add-on"
    task :update_interval => :environment do
        @regions_proactive = Region.where(is_proactive:true)
        @regions_proactive.each do |region|
            if (Date.current - region.proactive_start).to_i >= region.proactive_interval
                if region.morning == true && region.noon == true && region.night == true 
                    region.update(noon:false)
                elsif region.morning == true && region.night == true
                    region.update(morning:false)
                elsif region.morning == true && region.noon == true 
                    region.update(noon:false)
                elsif region.noon == true && region.night == true
                    region.update(noon:false)
                elsif region.interval < 7
                    region.increment!(:interval, 1)
                end
                region.update(proactive_start:Date.current)
            end
        end
    end
end