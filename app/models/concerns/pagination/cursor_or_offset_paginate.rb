# frozen_string_literal: true

module Pagination
  module CursorOrOffsetPaginate
    extend ActiveSupport::Concern
    include Pagination::CursorPaginate

    included do
      def self.cursor_or_offset_paginate(options = {})
        options[:cursor] ?
          cursor_paginate(options[:cursor], options[:per], options[:order]) :
          order(options[:order]).page(options[:page]).per(options[:per])
      end
    end
  end
end
