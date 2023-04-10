# == Schema Information
#
# Table name: start_time_plans
#
#  id         :uuid             not null, primary key
#  start_time :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_start_time_plans_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class StartTimePlan < ApplicationRecord
  belongs_to :user
  validate :start_time_within_allowed_range
  validates :start_time, presence: true

  private

  def start_time_within_allowed_range
    return if start_time.blank?

    allowed_start_time = 4.hours
    allowed_end_time = 10.hours

    unless start_time.seconds_since_midnight.between?(allowed_start_time, allowed_end_time)
      errors.add(:start_time, :not_within_allowed_range)
    end
  end
end
