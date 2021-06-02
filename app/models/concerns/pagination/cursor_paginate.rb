# frozen_string_literal: true

module Pagination
  module CursorPaginate
    extend ActiveSupport::Concern

    FIRST_PAGE_CURSOR = -2
    LAST_PAGE_CURSOR  = -1

    included do
      def self.cursor_paginate(cursor, per, order)
        begin
          cursor = Integer(cursor)
        rescue
          raise ArgumentError.new(I18n.t('cursor.errors.not_integer'))
        end

        return format_result([], LAST_PAGE_CURSOR, true) if cursor == LAST_PAGE_CURSOR

        order  ||= { id: :desc }
        limit  = per.try(:to_i) || 25
        models = order(order)
        models = compare_expression(models, order, cursor) unless cursor == FIRST_PAGE_CURSOR
        models = models.limit(limit + 1).to_a

        format_result(models, next_cursor(models, limit), last_page?(models, limit))
      end

      private

      def self.format_result(models, next_cursor, is_last_page)
        assign_cursor(models, next_cursor)
        models.pop unless is_last_page

        models
      end

      def self.assign_cursor(models, next_cursor)
        models.singleton_class.class_eval { attr_accessor :cursor }
        models.cursor = next_cursor
      end

      def self.compare_expression(models, order, cursor)
        sql = if order.values.first == :desc
                models.arel_table[order.keys.first].lteq(cursor).to_sql
              else
                models.arel_table[order.keys.first].gteq(cursor).to_sql
              end
        models.where(sql)
      end

      def self.last_page?(models, limit)
        models.count <= limit
      end

      def self.next_cursor(models, limit)
        last_page?(models, limit) ? LAST_PAGE_CURSOR : models.last.id
      end
    end
  end
end
