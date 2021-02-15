class Admin::Articles::PublishesController < ApplicationController
  layout 'admin'

  before_action :set_article

  def update
    @article.published_at = Time.current unless @article.published_at?
    @article.body = @article.build_body(self)

    if @article.valid?
      if @article.published_at <= Time.current
        Article.transaction do
          @article.state = :published
          @article.save
        end

        flash[:notice] = '記事を公開しました'
      elsif @article.published_at > Time.current
        Article.transaction do
          @article.state = :publish_wait
          @article.save
        end

        flash[:notice] = '記事を公開待ちにしました'
      end
      redirect_to edit_admin_article_path(@article.uuid)
    else
      flash.now[:alert] = 'エラーがあります。確認してください。'

      @article.state = @article.state_was if @article.state_changed?
      render 'admin/articles/edit'
    end
  end

  private

  def set_article
    @article = Article.find_by!(uuid: params[:article_uuid])
  end
end
