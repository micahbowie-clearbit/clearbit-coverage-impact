# frozen_string_literal: true
require 'active_support'
require 'hashie'
require 'clearbit/coverage_impact/models/column'
require 'clearbit/coverage_impact/models/row'

module Clearbit
  module CoverageImpact
    # Clearbit::CoverImpact::Query
    class Query
      attr_reader :data
      attr_accessor :query_params

      def initialize(data)
        @data = data
        @query_params = []
      end

      def count
        @data.row_count
      end

      def where!(query)
        query_params << query
        result = evalute_query
        decorate_result(result)
      end

      def where(query)
        query_params << query
        self
      end

      private

      def evalute_query
        data.rows.select do |row_data|
          row_criteria_met = []
          row_data.each do |column_before_and_after|
            wheres.each do |where_clause|
              column_data = Hashie::Mash.new(column_before_and_after)
              next unless column_data.data_point_name == where_clause.attribute_name && column_data.type.to_s == where_clause.query_type.to_s

              value = if column_data.send("value").is_a?(String)
                        "'#{column_data.send("value")}'"
                      elsif column_data.send("value").is_a?(NilClass)
                        'nil'
                      else
                        column_data.send("value")
                      end
              begin
                evaluation = eval("#{value} #{where_clause.query_criteria}")
              rescue SyntaxError => e
                evaluation = false
              end
              row_criteria_met << evaluation
            end
          end
          row_criteria_met.all?(true)
        end
      end

      def wheres
        @wheres ||= query_params.each_with_object([]) do |string, obj|
          column_name = string.split(' ').first
          query_type = column_name.include?('after') ? :after : :before
          attribute_name = column_name.gsub('after_', '').gsub('before_', '')
          query_criteria = string.split(' ').reject.each_with_index{|_i, ix| ix.zero? }.join('')
          obj << Hashie::Mash.new({column_name: column_name, query_type: query_type, attribute_name: attribute_name, query_criteria: query_criteria})
        end
      end

      def decorate_result(result)
        return [] unless result.present?

        result.map do |row|
          columns = row.map do |data|
            cd = Hashie::Mash.new(data)
            Column.new(name: cd.data_point_name, value: cd.value, type: cd.type)
          end
          Row.new(columns: columns)
        end
      end
    end
  end
end
