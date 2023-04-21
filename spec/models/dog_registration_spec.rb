require 'rails_helper'

RSpec.describe DogRegistration, type: :model do
  let!(:user) { create(:user) }
  let!(:dogrun_place) { create(:dogrun_place) }

  describe '#save' do
    context '入力値が正しい場合' do
      example 'DogとRegistrationNumberの数が1つ増えること' do
        dog_registration = DogRegistration.new(
          name: 'Bond', castration: true, public: true, user_id: user.id,
          registration_number: '5678', dogrun_place_id: dogrun_place.id,
          agreement: true
        )
        expect { dog_registration.save }.to change(Dog, :count).by(1).and change(RegistrationNumber, :count).by(1)
      end
    end

    describe '入力値に誤りがある場合' do
      context '全てのフォームが空のとき' do
        let(:form) do 
          DogRegistration.new(
            name: nil, 
            registration_number: nil, 
            user_id: nil,
            dogrun_place_id: nil,
            agreement: false
          )
        end
        example '登録されないこと' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:name, :blank)
          expect(form.errors).to be_of_kind(:registration_number, :blank)
          expect(form.errors).to be_of_kind(:user_id, :blank)
          expect(form.errors).to be_of_kind(:dogrun_place_id, :blank)
          expect(form.errors).to be_of_kind(:agreement, :accepted)
        end
      end

      context 'nameが51字以上のとき' do
        let(:form) do 
          DogRegistration.new(
            name: "a" * 51, 
          )
        end
        example 'name :too_longのメッセージが出ること' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:name, :too_long)
        end
      end
    end
  end
end
