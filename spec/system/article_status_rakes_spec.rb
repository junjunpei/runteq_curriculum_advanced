require 'rails_helper'

RSpec.describe "ArticleStatusRakes", type: :system do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/article_status'
    Rake::Task.define_task(:environment)
  end

  describe '公開待ちの中で、公開日時が過去のもののステータスを「公開」に変更するRakeタスク' do
    let(:article) { 'article_status:article_status_change' }

    it 'Rakeタスクが正常に実行される' do
      expect(@rake[article].invoke).to be_truthy
    end
  end
end
