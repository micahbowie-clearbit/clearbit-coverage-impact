# frozen_string_literal: true
require 'forwardable'
require 'terminal-table'

require_relative 'analyze'
require_relative 'csv'
require_relative 'data_store'
require_relative 'query'
require_relative 'saveable'
require_relative 'storable'

module Clearbit
  module CoverageImpact
    # Clearbit::CoverageImpact::Comparison
    class Comparison
      extend Forwardable
      include CoverageImpact::Storable
      include CoverageImpact::Saveable

      attr_accessor :data_points, :data_point_variables
      attr_reader :data

      def initialize
        @data_points = []
        @data_point_variables = []
        @data = DataStore.new.table
      end

      def self.create
        instance = new
        yield(instance)
        instance.send(:create_data_point_variables)
        instance
      end

      def establish_before_values(&block)
        self.class.send(:define_method, :execute_before_operation, block)
      end

      def define_operation(&block)
        self.class.send(:define_method, :execute_operation, block)
      end

      def establish_after_values(&block)
        self.class.send(:define_method, :execute_after_operation, block)
      end

      def execute!
        execute_before_operation
        puts '*** Done with before operation ***'
        execute_operation
        puts '*** Done with middle operation ***'
        execute_after_operation
        puts '*** Process complete ***'
      end

      def execute_and_analyze!
        execute!
        analyze
      end

      def create_csv!(location: nil, filename: nil)
        csv = ::Clearbit::CoverageImpact::Csv.new(
          data: data.rows,
          location: location,
          filename: filename,
          data_points: data_points
        )
        csv.create!
      end

      def analyze
        Clearbit::CoverageImpact::Analyze.print_analysis(data.rows)
      end

      def analysis
        Clearbit::CoverageImpact::Analyze.run(data.rows)
      end

      def_delegators :query,
        :count, :where, :where!

      def_delegators :data,
        :rows

      private

      def set_data!(store)
        @data = store.table
      end

      def query
        @query = Query.new(data)
      end

      def create_data_point_variables
        data_points.each do |data_point|
          self.class.send(:attr_accessor, data_point)
          data_point_variables << data_point
        end
      end
    end
  end
end
