class Core::Forecast
  CACHE_EXPIRATION = 30.minutes
  attr_accessor :address

  def initialize(address)
    @address = address
  end

  def call
    set_address
    cache_key = "forecast:#{address.postal_code}"
    cache_exists = Rails.cache.exist?(cache_key)

    forecast_data = Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRATION) do
      forecast_data = WeatherService.fetch_weather(address)

      format_response(forecast_data)
    end

    forecast_data.from_cache = cache_exists
    forecast_data
  end

  private

  def set_address
    @address = Geocoder.search(address).first

    raise 'Address not found' if address.blank?
  end

  def format_response(forecast_data)
    OpenStruct.new(
      current_temperature: forecast_data['temp'],
      high: forecast_data['temp_max'],
      low: forecast_data['temp_min'],
      extended_forecast: forecast_data['feels_like'],
      from_cache: false
    )
  end
end
