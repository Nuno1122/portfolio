module StartTimePlanHelper
    MINIMUM_UPDATES_COUNT = 0
  
    def confirmation_message(start_time_plan)
      start_time_plan.remaining_updates > MINIMUM_UPDATES_COUNT ? "return confirm('今月は残り#{start_time_plan.remaining_updates}回まで更新可能ですがよろしいですか？');" : ""
    end
  end