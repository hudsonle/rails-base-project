# frozen_string_literal: true

module Pagination
  module FetchPage
    extend ActiveSupport::Concern
    include Pagination::CursorOrOffsetPaginate

    module ClassMethods
      def filter(filtering_params)
        results = self.where(nil)
        filtering_params.each do |key, value|
          results = results.public_send(key, value) if value.present?
        end
        results
      end

      def filter_by_params(params)
        where(params) if params.present?
      end

      def fetch_page(options = {})
        default_sort_field, default_direction = ['updated_at', :desc]
        sort_field = options.fetch(:sort_field, default_sort_field)
        q          = options.fetch(:q, false)
        direction  = options.fetch(:direction, default_direction)
        filters    = options.fetch(:filters, nil)
        includes   = options.fetch(:includes, nil)
        options    = options
        order      = "#{sort_field} #{direction}"

        collections = where(nil).includes(includes)
        collections = collections.filter_by_params(format_filter_data(filters)) if filters
        collections = collections.search_by(q) if q
        collections = collections.reorder(order) if q && sort_field
        return collections if options[:page].to_i == -1

        # do not add more orders if sorting by rank
        collections.cursor_or_offset_paginate(options[:ranking_direction].present? ? options : options.merge(order: order))
      end

      def format_filter_data(filters)
        data = {}
        filters.each_key do |key|
          filter    = JSON.parse filters[key]
          data[key] = filter
        rescue JSON::ParserError
          data[key] = filters[key]
        end
        data
      end
    end
  end
end
