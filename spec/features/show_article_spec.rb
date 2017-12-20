require "rails_helper"

RSpec.feature "showing an article" do

  before do

  end

  scenario "A user shows an article" do
    @article = Article.create(title: "the first artricle", body: "Lorem ipsum dolor sit amet, consecteture")
    visit "/"
    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))
  end
end
