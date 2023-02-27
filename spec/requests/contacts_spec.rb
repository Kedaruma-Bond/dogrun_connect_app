require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe 'new_contacts_pathにget request' do
    before { get new_contacts_path }

    example 'レスポンスが正常なこと' do
      expect(response).to have_http_status(:success)
    end

    example 'titleが正しいこと' do
      expect(response.body).to include(I18n.t('defaults.contact'))
      expect(response.body).to include '| DogrunConnect'
    end
  end
end
