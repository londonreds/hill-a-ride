class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  skip_before_filter :authenticate_user!

  def index
    @events = Event.where("start_date >= now()").order("start_date")
    @events = @events.where(state: params[:filter_by]) if params[:filter_by]
    @states = State.all.order("swing DESC, name")
    page = params[:page]
    page ||= 1
    @events = @events.paginate(page: page, per_page: 50)
  end

  def show
    @cars = Car.joins(:user).where(event_id: @event.id).select("users.name, users.nickname, cars.city, cars.state, cars.num_of_seats_available, cars.id as car_id")
    @passengers = Passenger.joins(:user).where(event_id: @event.id).where("seats_still_needed > 0").select("users.name, users.nickname, passengers.city, passengers.state, passengers.seats_still_needed")
  end

  def ride_request

  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

end
