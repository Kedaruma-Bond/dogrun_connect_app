# 以下の設定でFactoryBotのデータ呼び出しを簡略化 FactoryBot.create(:◯◯) → create(:◯◯)
require 'factory_bot'

RSpec.configure do |config|
  config.before :all do
    FactoryBot.reload
  end
  config.include FactoryBot::Syntax::Methods
end
