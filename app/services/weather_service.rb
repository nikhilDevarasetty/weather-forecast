require 'net/http'
require 'json'

class WeatherService
  class << self
    API_BASE_URL = 'https://api.openweathermap.org/data/2.5/weather?'.freeze

    def fetch_weather(address)
      uri = weather_uri(address.longitude, address.latitude)
      response = Net::HTTP.get_response(uri)
      return JSON.parse(response.body)['main'] if response.is_a?(Net::HTTPSuccess)

      raise "unable to fetch information: #{response.code}, #{response.body}"
    end

    private

    def weather_uri(lng, lat)
      URI("#{API_BASE_URL}lat=#{lat}&lon=#{lng}&appid=#{Rails.application.credentials.open_weather_api_key}")
    end
  end
end
