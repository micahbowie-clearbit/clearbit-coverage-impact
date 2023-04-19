# frozen_string_literal: true

RSpec.describe Clearbit::CoverageImpact::Comparison do
  describe "#data" do
    it "returns a data class" do
      obj = Clearbit::CoverageImpact::Comparison.new

      expect(obj.data.class).to eq(Clearbit::CoverageImpact::DataStore)
    end
  end

  describe "#create" do
    it "defines attr reader for data point variables" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      expect(obj.respond_to?(:foo)).to be_truthy
    end

    it "defines attr writer for data point variables" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.respond_to?(:foo)

      expect(obj.respond_to?(:foo=)).to be_truthy
    end

    it "returns an instance of its self" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.respond_to?(:foo)

      expect(obj.class).to eq(Clearbit::CoverageImpact::Comparison)
    end
  end

  describe "#establish_before_values" do
    it "defines a new method" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      expect do
        obj.establish_before_values do
          @foo = "bar"
          puts "hello comparison"
        end
      end.to change { obj.methods.count }
    end

    it "defines the execute_before_operation method" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.establish_before_values do
        @foo = "bar"
        puts "hello comparison"
      end

      expect(obj.methods.include?(:execute_before_operation)).to be_truthy
    end
  end

  describe "#define_operation" do
    it "defines a new method" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      expect do
        obj.define_operation do
          @foo = "bar"
          puts "hello comparison"
        end
      end.to change { obj.methods.count }
    end

    it "defines the execute_operation method" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.define_operation do
        @foo = "bar"
        puts "hello comparison"
      end

      expect(obj.methods.include?(:execute_operation)).to be_truthy
    end
  end

  describe "#establish_after_values" do
    it "defines a new method" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      expect do
        obj.establish_after_values do
          @foo = "bar"
          puts "hello comparison"
        end
      end.to change { obj.methods.count }
    end

    it "defines the execute_after_operation method" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.establish_after_values do
        @foo = "bar"
        puts "hello comparison"
      end

      expect(obj.methods.include?(:execute_after_operation)).to be_truthy
    end
  end

  describe "#execute!" do
    it "calls execute_before_operation" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.establish_before_values do
        return "hey"
      end
      obj.define_operation do
        return "hello comparison"
      end
      obj.establish_after_values do
        return "hello comparison"
      end

      expect(obj).to receive(:execute_before_operation)
      obj.execute!
    end

    it "calls execute_operation" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.establish_before_values do
        return "hey"
      end
      obj.define_operation do
        return "hello comparison"
      end
      obj.establish_after_values do
        return "hello comparison"
      end

      expect(obj).to receive(:execute_operation)
      obj.execute!
    end

    it "calls execute_after_operation" do
      obj = Clearbit::CoverageImpact::Comparison.create { |config| config.data_points = ['foo'] }

      obj.establish_before_values do
        return "hey"
      end
      obj.define_operation do
        return "hello comparison"
      end
      obj.establish_after_values do
        return "hello comparison"
      end

      expect(obj).to receive(:execute_after_operation)
      obj.execute!
    end
  end
end
