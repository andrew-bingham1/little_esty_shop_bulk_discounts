class Holidays
  attr_reader :data, 
              :first_holiday, 
              :second_holiday, 
              :third_holiday

  def initialize(data)
    @data = data
    @first_holiday = @data[0]
    @second_holiday = @data[1]
    @third_holiday = @data[2]
  end

end