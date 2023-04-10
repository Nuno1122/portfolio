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
require 'rails_helper'

RSpec.describe StartTimePlan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
