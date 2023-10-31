# frozen_string_literal: true

require 'solareventcalculator'

class SunSetRize
  attr_reader :rize_time, :set_time

  def initialize
    set_sunset_sunrize_times
  end

  def add_night_class
    if night?
      'night'
    else
      ''
    end
  end

  def night?
    !Time.zone.now.between?(@rize_time, @set_time)
  end

  def formatted_rize_time
    rize_time.strftime('%k:%M')
  end

  def formatted_set_time
    set_time.strftime('%k:%M')
  end

  private

  def set_sunset_sunrize_times
    d = Date.today
    latitude = BigDecimal('35.676191')
    longitude = BigDecimal('139.650310')

    risecalc = SolarEventCalculator.new(d - 1.day, latitude, longitude)
    setcalc = SolarEventCalculator.new(d, latitude, longitude)
    @rize_time = risecalc.compute_official_sunrise('Asia/Tokyo').in_time_zone
    @set_time = setcalc.compute_official_sunset('Asia/Tokyo').in_time_zone
  end
end
