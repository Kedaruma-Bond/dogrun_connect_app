require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe '#create' do
    let(:user) { create(:user) }
    context '有効なemail addressが入力されたとき' do
      example 'password reset mailが送信されること' do
        expect do
          post password_resets_path, params: { email: user.email }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('password_resets.create.instruction'))
      end
    end

    context '無効なemail addressが入力されたとき' do
      example 'password reset mailが送信されないこと' do
        expect do
          post password_resets_path, params: { email: 'nonexistent@example.com' }
        end.not_to change { ActionMailer::Base.deliveries.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('password_resets.create.instruction'))
      end
    end
  end

  describe '#edit' do
    let(:user) { create(:user) }

    context '正しいリンクを開いたとき' do
      before { user.deliver_reset_password_instructions! }
      example 'パスワードリセットフォームが開くこと' do
        get edit_password_reset_path(user.reset_password_token)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(I18n.t('password_resets.edit.title'))
        expect(assigns(:token)).to eq(user.reset_password_token)
        expect(assigns(:user)).to eq(user)
      end
    end

    context '不正なリンクを開いたとき' do
      example 'home画面が開き、エラーメッセージが表示されること' do
        get edit_password_reset_path('invalid_token')

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.opened_incorrect_token_link'))
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user) }

    context '有効なパスワードが入力されたとき' do
      before { user.deliver_reset_password_instructions! }

      example '正常に動作すること' do
        patch password_reset_path(user.reset_password_token), params: { user: { password: 'new_pass', password_confirmation: 'new_pass' } }

        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq(I18n.t('password_resets.update.success'))
      end
    end

    context '無効なリンクを開いたとき' do
      example 'home画面が開き、エラーメッセージが表示されること' do
        patch password_reset_path('invalid_token'), params: { user: { password: 'new_pass', password_confirmation: 'new_pass' } } 

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t('defaults.opened_incorrect_token_link'))
      end
    end
    
    context '無効なパスワードが入力されたとき' do
      before { user.deliver_reset_password_instructions! }

      example 'パスワードはリセットされないこと' do
        patch password_reset_path(user.reset_password_token), params: { user: { password: 'new_password', password_confirmation: 'different_password' } }

        expect(response).to render_template(:edit)
      end
    end

  end
end
