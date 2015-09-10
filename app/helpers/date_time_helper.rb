module DateTimeHelper
  def shifted_date(datetime = Time.zone.now, offset = 3.hours)
    Time.zone.at(offset.ago(datetime)).to_date
  end
end
