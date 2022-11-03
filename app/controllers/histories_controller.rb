class HistoriesController < ApplicationController
  require 'date'
  before_action :authenticate_user!
  before_action :setup, only: %i[create_morning create_noon create_night create_yesterday_night]

  def setup
    @user = current_user
    @regions = Region.where(user_id: @user.id)
    @regions_create = []
  end

  def show
    month_in_display = if session[:month].nil?
                         Date.today
                       else
                         Date.today >> session[:month]
                       end
    days = month_in_display.end_of_month.day
    month = month_in_display.month
    @dates = []
    (1..days).each do |day|
      @dates.push("#{month}/#{day}")
    end
    @regions = Region.where(user_id: current_user.id).order('interval ASC').order('name ASC')
    @histories = []
    @regions.each do |region|
      colors = []
      colors.push(region.name)
      days.times do |day|
        if Itch.exists?(region_id: region.id, date: month_in_display.beginning_of_month + day.day)
          colors.push('red')
        else
          count = History.where(region_id: region.id, date: month_in_display.beginning_of_month + day.day).count
          if count == 0
            colors.push('colorless')
          elsif count == 1
            colors.push('light-skyblue')
          elsif count == 2
            colors.push('dark-skyblue')
          elsif count >= 3
            colors.push('blue')
          end
        end
      end
      @histories.push(colors)
    end
  end

  def create_morning
    @user = current_user
    @regions = Region.where(user_id: @user.id)
    @regions_create = []
    if Time.current.strftime('%H').to_i > 3
      @regions.each do |region|
        next unless (Date.current - region.last_morning).to_i >= region.interval

        if region.morning && !History.exists?(region_id: region.id, date: Date.current, is_yesterday: true)
          @regions_create.push(region)
        end
      end
      @regions_create.each do |region|
        region.histories.create({ date: Date.current, time: 'morning' })
        region.update(last_morning: Date.current)
      end
    else # 深夜0時〜3時59分
      @regions.each do |region|
        next unless (Date.current.yesterday - region.last_morning).to_i >= region.interval

        if region.morning && !History.exists?(region_id: region.id, date: Date.current.yesterday,
                                              is_yesterday: true)
          @regions_create.push(region)
        end
      end
      @regions_create.each do |region|
        region.histories.create({ date: Date.current.yesterday, time: 'morning' })
        region.update(last_morning: Date.current.yesterday)
      end
    end
    redirect_to root_path
  end

  def create_noon
    @user = current_user
    @regions = Region.where(user_id: @user.id)
    @regions_create = []
    if Time.current.strftime('%H').to_i > 3
      @regions.each do |region|
        next unless (Date.current - region.last_noon).to_i >= region.interval

        @regions_create.push(region) if region.noon
      end
      @regions_create.each do |region|
        region.histories.create({ date: Date.current, time: 'noon' })
        region.update(last_noon: Date.current)
      end
    else
      @regions.each do |region|
        next unless (Date.current.yesterday - region.last_noon).to_i >= region.interval

        @regions_create.push(region) if region.noon
      end
      @regions_create.each do |region|
        region.histories.create({ date: Date.current.yesterday, time: 'noon' })
        region.update(last_noon: Date.current.yesterday)
      end
    end
    redirect_to root_path
  end

  def create_night
    @user = current_user
    @regions = Region.where(user_id: @user.id)
    @regions_create = []
    if Time.current.strftime('%H').to_i > 3
      @regions.each do |region|
        next unless (Date.current - region.last_night).to_i >= region.interval

        @regions_create.push(region) if region.night
      end
      @regions_create.each do |region|
        region.histories.create({ date: Date.current, time: 'night' })
        region.update(last_night: Date.current)
      end
    else
      @regions.each do |region|
        next unless (Date.current.yesterday - region.last_night).to_i >= region.interval

        @regions_create.push(region) if region.night
      end
      @regions_create.each do |region|
        region.histories.create({ date: Date.current.yesterday, time: 'night' })
        region.update(last_night: Date.current.yesterday)
      end
    end
    redirect_to root_path
  end

  def create_yesterday_night
    @user = current_user
    @regions = Region.where(user_id: @user.id)
    @regions_create = []
    @regions.each do |region|
      next unless (Date.current.yesterday - region.last_night).to_i >= region.interval

      @regions_create.push(region) if region.night
    end
    @regions_create.each do |region|
      region.histories.create({ date: Date.current, time: 'morning', is_yesterday: true })
      region.update(last_night: Date.current.yesterday)
    end
    redirect_to root_path
  end

  def next_month
    session[:month] = 0 if session[:month].nil?
    session[:month] += 1
    redirect_to '/histories/show'
  end

  def prev_month
    session[:month] = 0 if session[:month].nil?
    session[:month] -= 1
    redirect_to '/histories/show'
  end
end
