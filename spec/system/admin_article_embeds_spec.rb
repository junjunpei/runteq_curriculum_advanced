require 'rails_helper'

RSpec.describe "AdminArticleEmbeds", type: :system do
  let(:article) { create :article }
  let(:admin)   { create :user }
  before do
    login_as(admin)
  end

  describe '埋め込みブロックを追加する' do
    context 'YouTubeのURLを追加する' do
      it '正常に動画が表示されること' do
        visit edit_admin_article_path(article.uuid)
        click_link 'ブロックを追加する'
        click_link '埋め込み'
        click_on '編集'
        select 'YouTube', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://youtu.be/TThQclOkSwU'
        all('.box-footer')[0].click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector("iframe[src='https://www.youtube.com/embed/TThQclOkSwU']")
      end
    end

    context 'TwitterのURLを追加する' do
      it '正常にツイートが表示されること' do
        visit edit_admin_article_path(article.uuid)
        click_link 'ブロックを追加する'
        click_link '埋め込み'
        click_on '編集'
        select 'Twitter', from: 'embed[embed_type]'
        fill_in 'ID', with: 'https://twitter.com/hisaju01/status/1363754862949789702?s=20'
        all('.box-footer')[0].click_button '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_content('RUNTEQ')
      end
    end
  end
end
