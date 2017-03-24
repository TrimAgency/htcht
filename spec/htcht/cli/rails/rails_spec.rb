require 'spec_helper'

describe Htcht::CLI::Rails::Rails do
  describe 'source root' do
    it 'returns the current working directory' do
      expect(described_class.source_root)
        .to match(%r{\/htcht\/lib\/htcht\/cli\/rails})
    end
  end

  describe 'building new Rails app with default template' do

    before :context do
      rails_generator = described_class.new
      rails_generator.new("HtchtTestRailsApi")
    end

    describe "building new Rails app" do
      it "creates the application director" do
        expect(system('ls htcht_test_rails_api')).to be true
      end
    end

    after :context do
      system("docker rmi htchttestrailsapi_app -f")
      FileUtils.remove_entry_secure("htcht_test_rails_api")
    end
  end
end
