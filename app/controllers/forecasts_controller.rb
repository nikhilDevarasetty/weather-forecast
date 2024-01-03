# controller to show weather details
class ForecastsController < ApplicationController
  def show
    @address = params[:address]
    @weather = Core::Forecast.new(@address).call if @address.present?
    flash[:error] = nil
  rescue => e
    flash[:error] = e.message
  end
end
