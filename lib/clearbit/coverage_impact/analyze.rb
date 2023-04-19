# frozen_string_literal: true
require 'hashie'
require 'colorize'

require_relative 'data_analyzation'

module Clearbit
  module CoverageImpact
    # Clearbit::CoverageImpact::Analyze
    class Analyze
      attr_reader :data, :data_points
      attr_accessor :analyzed_data

      def self.run(data)
        return [] unless data.present?

        instance = new(data)
        instance.calculate_change
      end

      def initialize(data)
        @data = data
        @data_points = searchable_data.deep_find_all(:data_point_name)&.uniq&.compact || []
      end

      def calculate_change
        calculate_null_change
        calculate_value_change
        decorate_data
      end

      def calculate_value_change
        searchable_data.each do |row|
          data_points.each do |dp|
            print '.'.colorize(:yellow)
            dp_columns = row.select { |x| x[:data_point_name] == dp }
            dp_columns.map! { |x| Hashie::Mash.new(x) }

            change = dp_columns[0].value != dp_columns[1].value
            change ? raw_analysis[dp.to_sym][:change] += 1 : raw_analysis[dp.to_sym][:no_change] += 1
          end
        end
      end

      def calculate_null_change
        searchable_data.each do |row|
          data_points.each do |dp|
            print ".".colorize(:yellow)
            dp_columns = row.select { |x| x[:data_point_name] == dp }
            dp_columns.map! { |x| Hashie::Mash.new(x) }

            if (dp_columns[0].value == nil) && (dp_columns[1].value != nil)
              raw_analysis[dp.to_sym][:nil_to_value_change] += 1
            end

            if (dp_columns[0].value != nil) && (dp_columns[1].value == nil)
              raw_analysis[dp.to_sym][:value_to_nil_change] += 1
            end
          end
        end
      end

      private

      def decorate_data
        puts ""
        raw_analysis.map do |key, value|
          row = Hashie::Mash.new(value)
          DataAnalyzation.new(
            name: key.to_s,
            change: row.change,
            no_change: row.no_change,
            nil_to_value_change: row.nil_to_value_change,
            value_to_nil_change: row.value_to_nil_change
          )
        end
      end

      def searchable_data
        data.extend(Hashie::Extensions::DeepFind) \
          .extend(Hashie::Extensions::DeepLocate) \
          .extend(Hashie::Extensions::IndifferentAccess)
      end

      def raw_analysis
        return @raw_analysis if @raw_analysis

        @raw_analysis = {}
        data_points.each do |dp|
          unless @raw_analysis[dp.to_sym]
            @raw_analysis[dp.to_sym] = { change: 0, no_change: 0, nil_to_value_change: 0, value_to_nil_change: 0 }
          end
        end
        @raw_analysis
      end
    end
  end
end
