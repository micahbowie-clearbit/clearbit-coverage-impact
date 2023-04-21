# frozen_string_literal: true

module Clearbit
  module CoverageImpact
    # Clearbit::CoverageImpact::DataAnalyzation
    class DataAnalyzation
      attr_reader :name, :total, :change, :no_change, :added, :dropped

      def initialize(name:, change: nil, no_change: nil, added: nil, dropped: nil)
        @name = name
        @change = change
        @no_change = no_change
        @added = added
        @dropped = dropped
        @total = (change + no_change)
      end

      def percent_of_change
        percent = ((change.to_f / total) * 100).ceil
        "#{percent}%"
      end

      def percent_of_unchanged
        percent = ((no_change.to_f / total) * 100).ceil
        "#{percent}%"
      end

      def percent_of_added
        percent = ((added.to_f / total) * 100).ceil
        "#{percent}%"
      end

      def percent_of_dropped
        percent = ((dropped.to_f / total) * 100).ceil
        "#{percent}%"
      end
    end
  end
end
