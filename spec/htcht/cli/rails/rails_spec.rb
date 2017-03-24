require 'spec_helper'

describe Htcht::CLI::Rails::Rails do
  describe 'source root' do
    it 'returns the current working directory' do
      expect(described_class.source_root)
        .to match(%r{\/htcht\/lib\/htcht\/cli\/rails})
    end
  end

  describe 'building new Rails apps' do

    before :context do
      rails_generator = described_class.new
      rails_generator.options = { api: true, init: false }
      rails_generator.new("HtchtTestRailsApi")
    end

    describe "building new Rails API" do
      it "is not testing anything atm" do
      end
    end

    after :context do
      system("docker rmi htchttestrailsapi_app -f")
      FileUtils.remove_entry_secure("htcht_test_rails_api")
    end
  end
end
