require 'rails_helper'

RSpec.describe "AdminArticlesPreviews", type: :system do
  let(:admin_user) { create(:user, :admin) }

  describe '記事作成画面で画像ブロックを追加' do
    context '画像を添付せずにプレビューを閲覧' do
      it 'プレビューが正常に表示される' do
        login_as(admin_user)
        click_link '記事'
        expect(current_path).to eq admin_articles_path
        click_link '新規作成'
        expect(current_path).to eq new_admin_article_path
        fill_in 'タイトル', with: 'foobar'
        click_button '登録する'
        click_link 'ブロックを追加する'
        click_link '画像'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_content('foobar')
      end
    end
  end
end