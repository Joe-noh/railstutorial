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
    quoted_true = ActiveRecord::Base.connection.quoted_true
    condition = "activated = #{quoted_true} AND random >= :random"

    num_stars = (User.where(activated: true).count / 100.0).ceil
    elected_ids = Set.new
    star_users = []

    while (star_users.size < num_stars)
      user = User.where(condition, random: Random.rand).order(random: :asc).limit(1).first

      if user.nil?
        user = User.where(condition, random: 0.0).order(random: :asc).limit(1).first
      end

      next if elected_ids.include?(user.id)

      elected_ids << user.id
      star_users << user
    end

    star_users
  end
end
