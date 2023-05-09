require 'rails_helper'

RSpec.describe Reon::StaticPagesController, type: :request do
  let!(:dogrun_place) { create(:dogrun_place, :reon) }

  describe 'GET #top' do
    context 'ログインしていない時' do
      before { get reon_top_path }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end
    end
  
    context 'ログインしているとき' do
      let!(:general) { create(:user, :general) }
      let!(:dog_1) { create(:dog, :castrated, :public_view) }
      let!(:rn_1) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place) }
      let!(:entry_1) { create(:entry, registration_number: rn_1, dog: dog_1, exit_at: nil) }
      let!(:dog_2) { create(:dog, :castrated, :non_public) }
      let!(:rn_2) { create(:registration_number, dog: dog_2, dogrun_place: dogrun_place) }
      let!(:entry_2) { create(:entry, registration_number: rn_2, dog: dog_2, exit_at: nil) }
      let!(:article) { create(:article, content: "test", post: create(:post, :article, :is_publishing, dogrun_place: dogrun_place)) } 

      before do
        reon_log_in_as(general)
        get reon_top_path
      end

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include(entry_1.dog.name)
        expect(response.body).not_to include(entry_2.dog.name)
        expect(response.body).to include(article.content)
      end
    end
  end
end
