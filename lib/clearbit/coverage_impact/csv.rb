# frozen_string_literal: true
require 'hashie'
require 'colorize'

module Clearbit
  module CoverageImpact
    # Clearbit::CoverImpact::Csv
    class Csv
      attr_accessor :filename, :location, :data, :data_points

      def initialize(data:, location:, filename:, data_points:)
        @filename = filename || "#{Time.now.strftime('%m%d%Y')}_before_and_after.csv"
        @location = location || "tmp/"
        @data = data
        @data_points = data_points
      end

      def file_path
        "#{location}#{filename}"
      end

      def create!
        CSV.open(file_path, "a+") do |csv|
          csv << headers if csv.count.zero?

          data.each do |row|
            sr = row.sort { |a, b| a[:data_point_name] <=> b[:data_point_name] }
            csv_row = sr.map { |column| column[:value] }
            csv << csv_row
          end
        end

        puts "** Your CSV has been created ***"
        puts "Your file is located: #{file_path}".colorize(:green)
      end

      private

      def headers
        @headers ||= data_points.sort.each_with_object([]) do |column, obj|
          obj << "before_#{column}"
          obj << "after_#{column}"
        end
      end
    end
  end
end
