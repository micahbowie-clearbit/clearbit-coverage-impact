# frozen_string_literal: true
require 'active_support'
require 'hashie'
require 'colorize'

require_relative 'data_analyzation'

module Clearbit
  module CoverageImpact
    class AnalyzeError < StandardError; end
    # Clearbit::CoverageImpact::Analyze
    class Analyze
      attr_reader :data, :data_points
      attr_accessor :analyzed_data

      def self.run(data)
        return [] unless data.present?

        instance = new(data)
        instance.calculate_change
      end

      def self.print_analysis(data)
        return [] unless data.present?

        instance = new(data)
        instance.print_analysis
      end

      def initialize(data)
        @data = data
        @data_points = searchable_data.deep_find_all(:data_point_name)&.uniq&.compact || []
        raise AnalyzeError.new('Can not find data point names') unless @data_points.present?
      end

      def calculate_change
        calculate_null_change
        calculate_value_change
        decorate_data
      end

      def print_analysis
        header = [%w[name change unchanged added dropped]]
        rows = calculate_change.each_with_object([]) do |ar, obj|
          obj << [ar.name, ar.percent_of_change, ar.percent_of_unchanged, ar.percent_of_added, ar.percent_of_dropped]
        end
        puts ::Terminal::Table.new(title: "Comparison Analysis", headings: header, rows: rows)
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
            character = '.'
            dp_columns = row.select { |x| x[:data_point_name] == dp }
            dp_columns.map! { |x| Hashie::Mash.new(x) }

            if dp_columns[0].value.nil? && (dp_columns[1].value != nil)
              raw_analysis[dp.to_sym][:added] += 1
              character = '*'
            end

            if (dp_columns[0].value != nil) && dp_columns[1].value.nil?
              raw_analysis[dp.to_sym][:dropped] += 1
              character = '*'
            end
            print character.colorize(:yellow)
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
            added: row.added,
            dropped: row.dropped
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
            @raw_analysis[dp.to_sym] = { change: 0, no_change: 0, added: 0, dropped: 0 }
          end
        end
        @raw_analysis
      end
    end
  end
end
