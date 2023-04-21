require 'rails_helper'

RSpec.describe DogFullyRegistration, type: :model do
  let!(:user) { create(:user) }
  let!(:dogrun_place) { create(:dogrun_place) }

  describe '#save' do
    context '入力値が正しい場合' do
      let(:form) do
        DogFullyRegistration.new(
          name: "bond",
          thumbnail: fixture_file_upload("/images/bond_icon.png", "image/png"),
          castration: false,
          public: true,
          birthday: Date.today - 1.year,
          breed: "ウィペット",
          sex: "male",
          weight: 10,
          mixed_vaccination_certificate: fixture_file_upload("/images/photo_of_mixed_vaccination_certificate.jpg", "image/jpg"),
          date_of_mixed_vaccination: Date.today - 1.month,
          rabies_vaccination_certificate: fixture_file_upload("/images/photo_of_rabies_vaccination_certificate.jpg", "image/jpg"),
          date_of_rabies_vaccination: Date.today - 1.month,
          registration_prefecture_code: 13,
          registration_municipality: "渋谷区",
          municipal_registration_number: "12345",
          license_plate: fixture_file_upload("/images/photo_of_license_plate.jpg", "image/jpg"),
          user_id: user.id,
          registration_number: "12345",
          dogrun_place_id: dogrun_place.id,
          agreement: true
        )
      end

      example "dogとregistration_numberが作成されること" do
        expect { form.save }.to change(Dog, :count).by(1).and change(RegistrationNumber, :count).by(1)
      end
    end

    describe '入力値に誤りがある場合' do
      context '全てのフォームが空のとき' do
        let(:form) do
          DogFullyRegistration.new(
            name: nil,
            thumbnail: nil,
            castration: false,
            public: false,
            birthday: nil,
            breed: nil,
            sex: nil,
            weight: nil,
            mixed_vaccination_certificate: nil,
            date_of_mixed_vaccination: nil,
            rabies_vaccination_certificate: nil,
            date_of_rabies_vaccination: nil,
            registration_prefecture_code: nil,
            registration_municipality: nil,
            municipal_registration_number: nil,
            license_plate: nil,
            user_id: nil,
            registration_number: nil,
            dogrun_place_id: nil,
            agreement: false
          )
        end
        example "登録されないこと" do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:name, :blank)
          expect(form.errors).to be_of_kind(:thumbnail, :not_attached)
          expect(form.errors).to be_of_kind(:birthday, :blank)
          expect(form.errors).to be_of_kind(:breed, :blank)
          expect(form.errors).to be_of_kind(:sex, :blank)
          expect(form.errors).to be_of_kind(:weight, :blank)
          expect(form.errors).to be_of_kind(:mixed_vaccination_certificate, :not_attached)
          expect(form.errors).to be_of_kind(:date_of_mixed_vaccination, :blank)
          expect(form.errors).to be_of_kind(:rabies_vaccination_certificate, :not_attached)
          expect(form.errors).to be_of_kind(:date_of_rabies_vaccination, :blank)
          expect(form.errors).to be_of_kind(:registration_prefecture_code, :blank)
          expect(form.errors).to be_of_kind(:registration_municipality, :blank)
          expect(form.errors).to be_of_kind(:municipal_registration_number, :blank)
          expect(form.errors).to be_of_kind(:license_plate, :not_attached)
          expect(form.errors).to be_of_kind(:user_id, :blank)
          expect(form.errors).to be_of_kind(:registration_number, :blank)
          expect(form.errors).to be_of_kind(:dogrun_place_id, :blank)
          expect(form.errors).to be_of_kind(:agreement, :accepted)
        end
      end

      context 'nameが51字以上のとき' do
        let(:form) do 
          DogFullyRegistration.new(
            name: "a" * 51, 
          )
        end
        example 'name :too_longのメッセージが出ること' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:name, :too_long)
        end
      end

      context 'breedが51字以上のとき' do
        let(:form) do 
          DogFullyRegistration.new(
            breed: "a" * 51, 
          )
        end
        example 'breed :too_longのメッセージが出ること' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:breed, :too_long)
        end
      end

      context 'weightが数字以外のとき' do
        let(:form) do 
          DogFullyRegistration.new(
            weight: "a", 
          )
        end
        example ':not_an_integerのメッセージが出ること' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:weight, :not_a_number)
        end
      end

      describe "weightの入力値" do
        context '0のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              weight: 0, 
            )
          end
          example ':greater_thanのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:weight, :greater_than)
          end
        end
        
        context '31字以上のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              registration_municipality: "a" * 31, 
            )
          end
          example 'registration_municipality :too_longのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:registration_municipality, :too_long)
          end
        end
      end
      
      context 'municipal_registration_numberが11字以上のとき' do
        let(:form) do 
          DogFullyRegistration.new(
            municipal_registration_number: "a" * 11, 
          )
        end
        example 'municipal_registration_number :too_longのメッセージが出ること' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:municipal_registration_number, :too_long)
        end
      end

      describe 'thumbnailの添付ファイル' do
        context '10MB以上のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              thumbnail: fixture_file_upload("/images/test_image.jpg", "image/jpg"),
            )
          end
          example ':file_size_out_of_rangeのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:thumbnail, :file_size_out_of_range)
          end
        end

        context '画像ファイルの形式以外のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              thumbnail: fixture_file_upload("/images/test_image_tiff.tiff", "image/tiff"),
            )
          end
          example ':content_type_invalidのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:thumbnail, :content_type_invalid)
          end
        end
      end
      
      describe 'rabies_vaccination_certificateの添付ファイル' do
        context '10MB以上のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              rabies_vaccination_certificate: fixture_file_upload("/images/test_image.jpg", "image/jpg"),
            )
          end
          example ':file_size_out_of_rangeのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:rabies_vaccination_certificate, :file_size_out_of_range)
          end
        end

        context '画像ファイルの形式以外のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              rabies_vaccination_certificate: fixture_file_upload("/images/test_image_tiff.tiff", "image/tiff"),
            )
          end
          example ':content_type_invalidのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:rabies_vaccination_certificate, :content_type_invalid)
          end
        end
      end

      describe 'mixed_vaccination_certificateの添付ファイル' do
        context '10MB以上のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              mixed_vaccination_certificate: fixture_file_upload("/images/test_image.jpg", "image/jpg"),
            )
          end
          example ':file_size_out_of_rangeのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:mixed_vaccination_certificate, :file_size_out_of_range)
          end
        end

        context '画像ファイルの形式以外のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              mixed_vaccination_certificate: fixture_file_upload("/images/test_image_tiff.tiff", "image/tiff"),
            )
          end
          example ':content_type_invalidのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:mixed_vaccination_certificate, :content_type_invalid)
          end
        end
      end
      
      describe 'license_plateの添付ファイル' do
        context '10MB以上のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              license_plate: fixture_file_upload("/images/test_image.jpg", "image/jpg"),
            )
          end
          example ':file_size_out_of_rangeのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:license_plate, :file_size_out_of_range)
          end
        end

        context '画像ファイルの形式以外のとき' do
          let(:form) do 
            DogFullyRegistration.new(
              license_plate: fixture_file_upload("/images/test_image_tiff.tiff", "image/tiff"),
            )
          end
          example ':content_type_invalidのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:license_plate, :content_type_invalid)
          end
        end
      end
    end
  end
end
