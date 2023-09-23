require 'rails_helper'

RSpec.describe ArticlePost, type: :model do
  let!(:user) { create(:user) }
  let!(:dogrun_place) { create(:dogrun_place) }
  let!(:admin) { create(:user, :admin, dogrun_place: dogrun_place) }
  
  describe '#save' do
    context '入力値が正しい場合' do
      let(:form) do
        ArticlePost.new(
          post_type: "article",
          publish_status: false,
          user_id: user.id,
          dogrun_place_id: dogrun_place.id,
          content: "test",
          photo: fixture_file_upload("/images/bond_icon.png", "image/png")
        )
      end

      example "postとarticleが作成されること" do
        expect { form.save }.to change(Post, :count).by(1).and change(Article, :count).by(1)
      end
    end

    describe '入力値に誤りがある場合' do
      context '全てのフォームが空のとき' do
        let(:form) do
          ArticlePost.new(
            post_type: nil,
            publish_status: nil,
            user_id: nil,
            dogrun_place_id: nil,
            content: nil,
            photo: nil
          )
        end

        example '登録されないこと' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:post_type, :blank)
          expect(form.errors).to be_of_kind(:publish_status, :blank)
          expect(form.errors).to be_of_kind(:user_id, :blank)
          expect(form.errors).to be_of_kind(:dogrun_place_id, :blank)
          expect(form.errors).to be_of_kind(:content, :blank)
        end
      end

      context 'contentフィールドが400字以上の場合' do
        let(:form) do
          ArticlePost.new(
            content: "a" * 401,
          )
        end
        example 'content :too_longのメッセージが出ること' do
          expect(form).to be_invalid
          expect(form.errors).to be_of_kind(:content, :too_long)
        end
      end

      describe 'photoの添付ファイル' do
        context '10MB以上のとき' do
          let(:form) do
            ArticlePost.new(
              photo: fixture_file_upload("/images/test_image.jpg", "image/jpg"),
            )
          end
          example 'photo :file_size_out_of_rangeのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:photo, :file_size_out_of_range)
          end
        end

        context '画像ファイルの形式以外のとき' do
          let(:form) do
            ArticlePost.new(
              photo: fixture_file_upload("/images/test_image_tiff.tiff", "image/tiff"),
            )
          end
          example 'photo :content_type_invalidのメッセージが出ること' do
            expect(form).to be_invalid
            expect(form.errors).to be_of_kind(:photo, :content_type_invalid)
          end 
        end
      end
    end
  end
end
