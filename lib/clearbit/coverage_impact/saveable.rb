# frozen_string_literal: true
require 'json'
require 'colorize'

require_relative 'data_store'

# This module gives users the ability to write there data to a
# JSON file locally so that they can save an operation
module Clearbit
  module CoverageImpact
    class SaveError < StandardError; end
    module Saveable
      def save_data(filename: nil, location: nil)
        if @data.present? && (@data.is_a?(Hash) || @data.is_a?(Array))
          sl = location || "tmp/"
          sf = filename || "#{Time.now.strftime('%m%d%Y')}_saveable_data.json"
          file_path = "#{sl}#{sf}"

          File.open(file_path,"w") do |f|
            f.write(@data.to_json)
          end

          puts "** Your JSON file has been created ***"
          puts "Your file is located: #{file_path}".colorize(:green)
          puts ''
          puts "** Save this file so that you can relaod it later **".colorize(:yellow)
        else
          raise Clearbit::CoverageImpact::SaveError.new("Couldn't save data")
        end
      end

      def load_data(file_path)
        file = File.open(file_path)
        data = JSON.load(file)

        table = Clearbit::CoverageImpact::DataTable.new
        table.set_data!(data)
        store = Clearbit::CoverageImpact::DataStore.new(table: table)
        set_data!(store)

        puts "** Your JSON file has been loaded ***".colorize(:green)
      end
    end
  end
end
