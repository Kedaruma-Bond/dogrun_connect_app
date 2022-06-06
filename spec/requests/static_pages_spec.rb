require 'rails_helper'

RSpec.describe 'static_pages #request', type: :request do
  describe 'loginしていない状態' do
    context 'root_pathにget requestするとき' do
      before { get '/' }
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status 200
      end
      it 'タイトルが DogrunConnectになること' do
        expect(response.body).to include 'DogrunConnect'
      end
      it '画面上にログインと新規登録の記載がないこと' do
        expect(response.body).to_not include 'ログイン'
        expect(response.body).to_not include '新規登録'
      end
    end

    context '利用規約ページにget requestするとき' do
      before { get terms_of_service_path }
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status 200
      end
      it 'タイトルが適当なものに変更していること' do
        expect(response.body).to include '利用規約'
        expect(response.body).to include '| DogrunConnect'
      end
    end

    context 'プライバシーポリシーページにget requestするとき' do
      before { get privacy_policy_path }
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status 200
      end
      it 'タイトルが適当なものに変更していること' do
        expect(response.body).to include 'プライバシーポリシー'
        expect(response.body).to include '| DogrunConnect'
      end
    end

    context 'お問い合わせページにget requestするとき' do
      before { get new_contact_path }
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status 200
      end
      it 'タイトルが適当なものに変更していること' do
        expect(response.body).to include 'お問い合わせ'
        expect(response.body).to include '| DogrunConnect'
      end
    end

    context 'お問い合わせ内容確認ページにpost requestするとき' do
      before do
        post confirm_path, params: { contact: { name: 'TestUser', email: 'test@example.com', message: 'test' } }
      end
      it 'レスポンスが正常なこと' do
        expect(response).to render_template(:confirm)
      end
      it 'タイトルが適当なものに変更していること' do
        expect(response.body).to include 'お問い合わせ内容確認'
        expect(response.body).to include '| DogrunConnect'
      end
    end
  end
end
