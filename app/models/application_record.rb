class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Pagination::FetchPage

  def created_at_timestamp
    created_at.to_i
  end

  def updated_at_timestamp
    updated_at.to_i
  end

  def installment_date_timestamp
    installment_date.to_i
  end
end
