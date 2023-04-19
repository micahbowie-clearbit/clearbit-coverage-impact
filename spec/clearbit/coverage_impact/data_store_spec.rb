# frozen_string_literal: true

RSpec.describe Clearbit::CoverageImpact::DataStore do
  it "can deep select data" do
    rows = {
      one: [{ data_point_name: 'count', before_value: 60, after_value: 70 }, { data_point_name: 'place', before_value: 'ohio', after_value: 'texas' }],
      two: [{ data_point_name: 'count', before_value: 20, after_value: 90 }, { data_point_name: 'place', before_value: 'columbus', after_value: 'austin' }],
    }
    obj = Clearbit::CoverageImpact::DataStore.new
    obj.rows = rows
    obj.rows.extend(Hashie::Extensions::DeepLocate)

    selection = obj.rows.deep_locate -> (key, value, object) do
      key == :data_point_name && value == 'place' && object[:before_value] == 'ohio'
    end
    expect(selection).to eq([{:after_value=>"texas", :before_value=>"ohio", :data_point_name=>"place"}])
  end
end
