class LunchesController < ApplicationController
  def index
    @date = Date.parse(params[:date]) rescue Date.today.next_occurring(:friday)
    @day_ok = day_ok?
    @can_register = @current_user.lunches.new(date: @date).valid? && @day_ok
    @other_lunches = Lunch.on(@date).order(:created_at)
  end

  def create
    @date = Date.parse(params[:date])

    if day_ok?
      @lunch = @current_user.lunches.create(date: @date)

      register_same_day if day_ok? && @date == Date.today
    else
      flash[:error] = 'Please only register for Fridays.'
    end

    redirect_to root_path(date: @date)
  end

  def destroy
    lunch = @current_user.lunches.find(params[:id])
    group = lunch.group if lunch.group
    date = lunch.date

    lunch.destroy
    send_updates(group) if group

    flash[:notice] = 'Your break was canceled.'
    redirect_to root_path(date: date)
  end

  private

  def day_ok?
    weekday = @date.friday?
    day = Time.now < Date.today.midday - 1.hour || @date.future?
    weekday && day
  end

  def register_same_day
    return Group.create_all_groups!(date: Date.today) if Group.on(Date.today).count.zero?

    @lunch.add_single_to_group
    @lunch.group.lunches.each do |lunch|
      UserMailer.lunch_confirmed_mail(lunch).deliver_later
    end
  end

  def send_updates(group)
    if @current_user == group.leader
      group.update(leader: group.lunches.sample.user)
    end

    group.lunches.each do |lunch|
      UserMailer.lunch_confirmed_mail(lunch).deliver_later
    end
  end
end
