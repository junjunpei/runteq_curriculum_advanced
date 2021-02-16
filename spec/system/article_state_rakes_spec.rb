require 'rake_helper'

describe "article_state:article_state_change" do
  subject(:task) { Rake.application['article_state:article_state_change'] }

  before do
    create(:article, state: :publish_wait, published_at: Time.current - 1.day)
    create(:article, state: :publish_wait, published_at: Time.current + 1.day)
    create(:article, state: :draft)
  end

  it 'article_state_change' do
    expect{ task.invoke }.to change { Article.published.size }.from(0).to(1)
  end
end
