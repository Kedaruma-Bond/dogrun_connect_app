require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe '#new' do
    context 'GET requestしたとき' do
      before { get new_contacts_path }
  
      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#confirm' do
    context '有効なパラメータをPOST requestしたとき' do
      before { post confirm_path, 
        params: { 
          contact: { 
            name: 'test', 
            email: 'test@example.com', 
            message: 'test message' 
          } 
        } 
      }

      example 'レスポンスが正常なこと' do
        expect(response).to have_http_status(:success)
      end
      
      example 'session[:contact]に情報が格納されていること' do
        expect(session[:contact]).to eq("name"=>"test", "email"=>"test@example.com", "message"=>"test message")
      end
    end
    
    context '無効なパラメータをPOST requestしたとき' do
      before { post confirm_path, 
        params: { 
          contact: { 
            name: '', 
            email: '', 
            message: '' 
          } 
        } 
      }

      example 'フォームに戻ること' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#create' do
    context '有効なパラメータを送信した場合' do
      before do
        post confirm_path, 
          params: { 
            contact: { 
              name: 'test', 
              email: 'test@example.com', 
              message: 'test message' 
            } 
          }
      end

      example "新規作成され、トップページにリダイレクトする" do
        expect do
          post contacts_path
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        # allow(ContactMailer).to receive_message_chain(:send_mail, :deliver_now)
        expect(response).to redirect_to(root_path)
        expect(session[:contact]).to be_nil
        expect(flash[:success]).to eq(I18n.t('contacts.create.success'))
      end
    end
  end
end
