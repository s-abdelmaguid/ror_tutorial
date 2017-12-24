require 'rails_helper'

RSpec.describe "Article", type: :request do
  before do
    @john = User.create(email: "john@example.com", password: "password")
    @fred = User.create(email: "fred@example.com", password: "password")
    @article = Article.create!(title: "Title one", body: "body of title one", user:@john)
  end

  describe 'GET /articles/:id/edit' do

    context 'with non signed in user' do
      before { get "/articles/#{@article.id}/edit"}

      it "redirects to sign in page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in user who is not owner' do
        before do
          login_as(@fred)
          get "/articles/#{@article.id}/edit"
        end
        it "redirects to sign in page" do
          expect(response.status).to eq 302
          flash_message = "you can only edit your own articles"
          expect(flash[:alert]).to eq flash_message
        end
      end

    context "with sign in user as owner successful edit" do
      before do
        login_as(@john)
        get "/articles/#{@article.id}/edit"
      end
        it "successfully edit article" do
          expect(response.status).to eq 200
        end
     end
  end

  describe 'GET /articles/:id' do
    context 'with existing article' do
      before { get "/articles/#{@article.id}"}

      it "handles existing article" do
        expect(response.status).to eq 200
      end
    end

    context 'with non-existing article' do
      before { get "/article/xxxx" }

      it "handles non-existing article" do
        expect(response.status).to eq 302
        flash_message = "The article you are looking for could not be found"
        expect(flash[:alert].to eq flash_message)
      end
    end

  end
end
