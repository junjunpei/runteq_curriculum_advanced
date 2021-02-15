namespace :article_status do
  desc '公開待ちの中で、公開日時が過去のもののステータスを「公開」に変更する'
  task article_status_change: :environment do
    Article.where(state: 'publish_wait').find_each do |article|
      if article.published_at <= Time.current
        article.state = :published
        article.save
      end
    end
  end
end
