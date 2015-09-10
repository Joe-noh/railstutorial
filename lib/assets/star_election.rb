class StarElection
  def initialize(date)
    @date = date
  end

  def elect!
    elect_stars.each do |star_user|
      star_user.stars.create(date: @date, status: :candidate)
    end
  end

  private

  def elect_stars
    num_stars = (User.count / 100.0).ceil
    max_id = User.all.order(id: :desc).first.id
    elected_ids = Set.new
    stars = []

    while (stars.size < num_stars)
      id = Random.rand(max_id)

      if !elected_ids.include?(id) && user = User.find_by(id: id)
        elected_ids << id
        stars << user
      end
    end

    stars
  end
end
