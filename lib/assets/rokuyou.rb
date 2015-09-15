class Rokuyou
  def initialize(date)
    @qreki = Qreki.calc_from_date(date)
  end

  def taian?
    @qreki.rokuyou == "大安"
  end

  def shakko?
    @qreki.rokuyou == "赤口"
  end

  def sensho?
    @qreki.rokuyou == "先勝"
  end

  def tomobiki?
    @qreki.rokuyou == "友引"
  end

  def senpu?
    @qreki.rokuyou == "先負"
  end

  def butsumetsu?
    @qreki.rokuyou == "仏滅"
  end
end
