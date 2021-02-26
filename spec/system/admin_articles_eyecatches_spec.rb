require 'rails_helper'

RSpec.describe "AdminArticlesEyecatches", type: :system do
  let!(:article) { create :article }
  let(:admin) { create :user, :admin }

  before do
    login_as(admin)
    visit edit_admin_article_path(article.uuid)
    attach_file 'アイキャッチ', "#{Rails.root}/public/images/eye_catch.jpg"
    click_on '更新する'
  end

  describe 'アイキャッチの横幅を変更' do
    context '横幅を100~700pxに指定した場合' do
      it '記事の更新に成功し、プレビューでアイキャッチが確認できる' do
        eyecatch_width = rand(100..700)
        fill_in 'アイキャッチ幅', with: eyecatch_width
        click_on '更新する'
        expect(page).to have_content('更新しました')
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_css('.eye_catch')
        expect(current_path).to eq(admin_article_preview_path(article.uuid))
        expect(page).to have_selector("img[src$='eye_catch.jpg']")
        expect(page).to have_selector("img[width='#{eyecatch_width}']")
      end
    end

    context '横幅を99px以下に指定した場合' do
      it '記事の更新に失敗する' do
        fill_in 'アイキャッチ幅', with: rand(99)
        click_on '更新する'
        expect(page).not_to have_content('更新しました')
        expect(page).to have_content('は100以上の値にしてください')
      end
    end

    context '横幅を701px以上に指定した場合' do
      it '記事の更新に失敗する' do
        fill_in 'アイキャッチ幅', with: rand(701..1000)
        click_on '更新する'
        expect(page).not_to have_content('更新しました')
        expect(page).to have_content('は700以下の値にしてください')
      end
    end
  end

  describe 'アイキャッチ幅の表示位置を変更' do
    context 'アイキャッチ画像の位置を「右寄せ」に設定した場合' do
      it 'アイキャッチが「右寄せ」で表示される' do
        choose '右寄せ'
        click_on '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-right')
      end
    end

    context 'アイキャッチ画像の位置を「中央揃え」に設定した場合' do
      it 'アイキャッチが「中央揃え」で表示される' do
        choose '中央揃え'
        click_on '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-center')
      end
    end

    context 'アイキャッチ画像の位置を「左寄せ」に設定した場合' do
      it 'アイキャッチが「左寄せ」で表示される' do
        choose '左寄せ'
        click_on '更新する'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_selector('section.eye_catch.text-left')
      end
    end
  end
end
