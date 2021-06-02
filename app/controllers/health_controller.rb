# frozen_string_literal: true

class HealthController < ApplicationController
  def show
    render json: { server_time: (Time.zone.now.to_f * 1e3).to_i }
  end
end
