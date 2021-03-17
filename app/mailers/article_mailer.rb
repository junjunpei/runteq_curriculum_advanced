class ArticleMailer < ApplicationMailer
  def report_summary
    @articles = Article.where(state: :published)
    @yesterday_articles = Article.where(published_at: 1.day.ago.all_day)
    mail(to: 'admin@example.com', subject: '公開済記事の集計結果')
  end
end
