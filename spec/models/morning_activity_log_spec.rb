# == Schema Information
#
# Table name: morning_activity_logs
#
#  id                 :bigint           not null, primary key
#  started_time       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_time_plan_id :bigint           not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_morning_activity_logs_on_start_time_plan_id  (start_time_plan_id)
#  index_morning_activity_logs_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (start_time_plan_id => start_time_plans.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe MorningActivityLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
