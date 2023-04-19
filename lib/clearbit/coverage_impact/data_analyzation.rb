# frozen_string_literal: true
require 'hashie'

module Clearbit
  module CoverageImpact
    # Clearbit::CoverageImpact::DataAnalyzation
    class DataAnalyzation
      attr_reader :name, :total, :change, :no_change, :nil_to_value_change, :value_to_nil_change

      def initialize(name:, change: nil, no_change: nil, nil_to_value_change: nil, value_to_nil_change: nil)
        @name = name
        @change = change
        @no_change = no_change
        @nil_to_value_change = nil_to_value_change
        @value_to_nil_change = value_to_nil_change
        @total = (change + no_change)
      end

      def percent_of_change
        (change.to_f / total.to_f) * 100
      end

      def percent_of_unchanged
        (no_change.to_f / total.to_f) * 100
      end

      def percent_of_change_from_nil_to_value
        (nil_to_value_change.to_f / total.to_f) * 100
      end

      def percent_of_change_from_value_to_nil
        (value_to_nil_change.to_f / total.to_f) * 100
      end
    end
  end
end
