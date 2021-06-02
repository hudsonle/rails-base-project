# frozen_string_literal: true

class AdminAbility
  FULL_PERMISSION = 'all'
  include CanCan::Ability

  def initialize(admin_user)
    return unless admin_user
    admin_user["roles"].each do |role|
      role["permissions"].each do |permission|
        if permission["model"] == FULL_PERMISSION
          can permission["action"].to_sym, permission["model"].to_sym
        else
          can permission["action"].to_sym, permission["controller"]&.constantize rescue nil
        end
      end
    end
  end
end
