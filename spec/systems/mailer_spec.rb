require 'rails_helper'

RSpec.describe 'Mailer', type: :system do
  describe 'ContactMailer送信' do
    let(:contact) { build(:contact) }
    let(:mail) { ContactMailer.send_mail(contact).deliver_now }
    let(:check_sent_mail) do
      expect(mail.present?).to be_truthy, 'メールが送信されていません'
      expect(mail.to).to eq([Rails.application.credentials.contacts[:MAILER_USER_ID]]), 'メールの送信先が正しくありません'
      expect(mail.subject).to eq(I18n.t('contact_mailer.send_mail.subject')), 'メールのタイトルが正しくありません'
    end

    context 'メールを送信した場合' do
      example 'タイトル、メールアドレスが正しく送信される' do
        check_sent_mail
      end
    end
  end
end
