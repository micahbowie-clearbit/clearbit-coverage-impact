# frozen_string_literal: true

RSpec.describe Clearbit::CoverageImpact::Row do
  # This is testing the meta programming of the Row class
  # That allows .column_name_here be called on the row and return the column
  describe "#before_" do
    it 'returns the column in the row by that name' do
      column = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Texas', type: 'before')
      column_two = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Ohio', type: 'after')

      row = Clearbit::CoverageImpact::Row.new(id: 1, columns: [column, column_two])

      # we can use before_state because the column name for the column is state and the type is before
      expect(row.before_state).to eq(column)
    end

    it 'raises and error for an invalid column name' do
      column = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Texas', type: 'before')
      column_two = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Ohio', type: 'after')

      row = Clearbit::CoverageImpact::Row.new(id: 1, columns: [column, column_two])

      # we can use before_state because the column name for the column is state and the type is before
      expect { row.before_something_fake }.to raise_error(NoMethodError)
    end
  end

  describe "#after_" do
    it 'returns the column in the row by that name' do
      column = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Texas', type: 'before')
      column_two = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Ohio', type: 'after')

      row = Clearbit::CoverageImpact::Row.new(id: 1, columns: [column, column_two])

      # we can use before_state because the column name for the column is state and the type is before
      expect(row.after_state).to eq(column_two)
    end

    it 'raises and error for an invalid column name' do
      column = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Texas', type: 'before')
      column_two = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Ohio', type: 'after')

      row = Clearbit::CoverageImpact::Row.new(id: 1, columns: [column, column_two])

      # we can use before_state because the column name for the column is state and the type is before
      expect { row.after_something_fake }.to raise_error(NoMethodError)
    end
  end
end
