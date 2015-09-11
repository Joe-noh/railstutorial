class Star < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :date, presence: true
  validates :status, presence: true, inclusion: {in: %i[candidate accepted declined]}

  def status
    read_attribute(:status).to_s.to_sym
  end

  def candidate?; status == :candidate end
  def accepted?; status == :accepted end
  def declined?; status == :declined end

  # Returns whether a star campaign is being active at the given date
  def self.active?(date)
    Star.exists?(date: date)
  end
end
