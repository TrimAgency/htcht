require 'spec_helper'

describe Htcht::Main do
  describe 'subcommands' do
    it 'has a rails task' do
      rails_task = described_class.tasks['rails']

      expect(rails_task.name).to match(/\Arails\z/)
      expect(rails_task.usage).to match(/\Arails\sCOMMANDS\z/)
    end
  end
end
