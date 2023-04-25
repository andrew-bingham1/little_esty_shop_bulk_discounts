require './app/services/holidays_service.rb'
require './app/poros/holidays.rb'
require 'json'
require 'httparty'

class HolidaysBuilder
  def self.service
    HolidaysService.new
  end

  def self.next_holidays
    Holidays.new(service.holidays)
  end
end