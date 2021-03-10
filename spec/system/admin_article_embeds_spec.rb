require 'rails_helper'

RSpec.describe "AdminArticleEmbeds", type: :system do
  let(:article) { create :article }
  let(:admin)   { create :user, :admin }

  describe '埋め込みブロックを追加する' do
    before do
      login_as(admin)
      article
      visit edit_admin_article_path(article.uuid)
      click_on('ブロックを追加する')
      click_on('埋め込み')
      click_on('編集')
    end

    context 'YouTubeを選択しアップロード' do
      it 'プレビューした記事にYouTubeが埋め込まれていること' do
        select 'YouTube', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://youtu.be/TThQclOkSwU'
        page.all('.box-footer')[0].click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid))
        expect(page).to have_selector("iframe[src='https://www.youtube.com/embed/TThQclOkSwU']")
      end
    end

    context 'Twitterの選択しアップロード' do
      it 'プレビューした記事にTwitterが埋め込まれていること', js: true do
        select 'Twitter', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://twitter.com/hisaju01/status/1363754862949789702?s=20'
        page.all('.box-footer')[0].click_button '更新する'
        sleep 10
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(current_path).to eq(admin_article_preview_path(article.uuid))
        sleep 10
        expect(page).to have_selector("iframe[title='Twitter Tweet']")
      end
    end
  end
end
