require 'rails_helper'

RSpec.describe 'static_pages #request', type: :request do
  describe 'loginしていない状態' do
    context 'root_pathにget requestするとき' do
      before { get root_path }
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status 200
      end
      it "タイトルが 'こねこねマインド'になること" do
        expect(response.body).to include full_title('')
        expect(response.body).to_not include '| こねこねマインド'
      end
    end

    context '新規登録ページにget requestするとき' do
      before { get signup_path }
      it 'レスポンスが正常なこと' do
        expect(response).to have_http_status 200
      end
      it 'タイトルが適当なものに変更していること' do
        expect(response.body).to include full_title('新規登録')
        expect(response.body).to include '| こねこねマインド'
      end
    end
  end
end
