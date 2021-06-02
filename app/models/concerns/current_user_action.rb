module CurrentUserAction
  extend ActiveSupport::Concern

  included do
    class << self
      def current_user
        Thread.current[:current_user]
      end

      def current_user=(current_user)
        Thread.current[:current_user] = current_user
      end

      def current_token=(current_token)
        Thread.current[:current_token] = current_token
      end

      def current_token
        Thread.current[:current_token]
      end

      def current_request_info
        Thread.current[:current_request_info]
      end

      def current_request_info=(current_request_info)
        Thread.current[:current_request_info] = current_request_info
      end

      def access_token_expiry_time
        Thread.current[:access_token_expiry_time]
      end

      def access_token_expiry_time=(access_token_expiry_time)
        Thread.current[:access_token_expiry_time] = access_token_expiry_time
      end
    end
  end
end
