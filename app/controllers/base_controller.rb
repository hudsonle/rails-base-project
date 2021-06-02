class BaseController < ApplicationController

  private

  def without_paging
    params[:page].to_i == -1
  end

  def params_index
    params.permit(:q, :sort_field, :direction, :cursor, :page, :per, filters: {}).to_h.symbolize_keys
  end

  def with_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
