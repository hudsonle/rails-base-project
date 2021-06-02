# without table association

class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include CurrentUserAction

  def persisted?
    false
  end

  class << self
    def full_name
      "#{User.current_user.first_name} #{User.current_user.last_name}"
    end
  end
end
