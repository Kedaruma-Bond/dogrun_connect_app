require 'rails_helper'

RSpec.describe 'Users', type: :request do
  it 'factorybotの確認' do
    expect(build(:user)).to be_valid
  end

  describe '名前空間 togo_inu_shitsuke_hiroba' do
    let!(:dogrun_place) { FactoryBot.create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
    context '/signupにget request' do
      before { get togo_inu_shitsuke_hiroba_signup_path }
      
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end

      it 'タイトルが正常なこと' do
        expect(response.body).to include(I18n.t('togo_inu_shitsuke_hiroba.users.new.title'))
      end
    end

    describe '/signupにpost request' do
      #attributes_forはhashでuser情報を返してくれる
      let!(:user) {FactoryBot.attributes_for(:user) }
      context '有効な値で登録されるとき' do
        it 'ユーザーが正常に登録され、ウェルカムメールが送信されること' do
          aggregate_failures do
            expect do
              post togo_inu_shitsuke_hiroba_users_path, params: { user: user }
              # ユーザーがひとつ増えていることを確認
            end.to change(User, :count).by(1)
            # 配信メールが１通であることの確認
            expect(ActionMailer::Base.deliveries.size).to eq(1)
            expect(response).to redirect_to togo_inu_shitsuke_hiroba_dog_registration_path
            expect(is_logged_in?).to be_truthy
          end
        end
      end

      context '無効な値で登録されるとき' do
        let!(:user_params) do
          attributes_for(:user, name: '',
                                email: 'user@invalid',
                                password: '',
                                password_confirmation: '',)
        end

        it 'ユーザーが登録されないこと' do
          expect do
            post togo_inu_shitsuke_hiroba_users_path, params: { user: user_params }
          end.to change(User, :count).by(0)
        end
      end
    end

    describe 'user#showにget request' do
      let!(:user) { FactoryBot.create(:user) }
      it 'レスポンスが正常なこと' do
        log_in_as(user)
        get togo_inu_shitsuke_hiroba_user_path(user)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
