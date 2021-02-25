require 'rails_helper'

RSpec.describe "AdminArticles", type: :system do
  let(:admin_user) { create :user, :admin }
  let(:draft_article) { create :article, :draft }
  let(:future_article) { create :article, :future }
  let(:past_article) { create :article, :past }
  before do
    login_as(admin_user)
  end

  describe '記事編集画面' do
    context '公開日時を未来の日付に設定し「公開する」を押す' do
      it 'ステータスを「公開待ち」に変更して「記事を公開待ちにしました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(future_article.uuid)
        click_on '公開する'
        expect(page).to have_content('公開待ちにしました')
        expect(page).to have_select('状態', selected: '公開待ち')
      end
    end

    context '公開日時を過去の日付に設定し「公開する」を押す' do
      it 'ステータスを「公開」に変更して「記事を公開しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        click_on '公開する'
        expect(page).to have_content('公開しました')
        expect(page).to have_select('状態', selected: '公開')
      end
    end

    context 'ステータスが下書き以外の状態で公開日時を未来の日付に設定し「更新する」を押す' do
      it 'ステータスを「公開待ち」に変更して「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(future_article.uuid)
        click_on '更新する'
        expect(page).to have_content('更新しました')
        expect(page).to have_select('状態', selected: '公開待ち')
      end
    end

    context 'ステータスが下書き以外の状態で公開日時を過去の日付に設定し「更新する」を押す' do
      it 'ステータスを「公開」に変更して「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        click_on '更新する'
        expect(page).to have_content('更新しました')
        expect(page).to have_select('状態', selected: '公開')
      end
    end

    context 'ステータスが下書き状態で「更新する」を押す' do
      it 'ステータスは「下書き」のまま「更新しました」とフラッシュメッセージが表示されること' do
        visit edit_admin_article_path(draft_article.uuid)
        click_on '更新する'
        expect(page).to have_content('更新しました')
        expect(page).to have_selector(:css, '.form-control', text: '下書き')
      end
    end

    context 'アイキャッチ幅を99にして「更新する」を押す' do
      it '「100以上の値にしてください」というバリデーションエラーが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        fill_in 'アイキャッチ幅', with: 99
        click_on '更新する'
        expect(page).to have_content('100以上の値にしてください')
      end
    end

    context 'アイキャッチ幅を701にして「更新する」を押す' do
      it '「700以下の値にしてください」というバリデーションエラーが表示されること' do
        visit edit_admin_article_path(past_article.uuid)
        fill_in 'アイキャッチ幅', with: 701
        click_on '更新する'
        expect(page).to have_content('700以下の値にしてください')
      end
    end

    context 'アイキャッチ幅を400にして「更新する」を押し、プレビューを押す' do
      it '更新が成功すること' do
        visit edit_admin_article_path(past_article.uuid)
        fill_in 'アイキャッチ幅', with: 400
        click_on '更新する'
        expect(page).to have_content('更新しました')
      end
    end

    describe '検索機能' do
      let(:article_with_author) { create(:article, :with_author, author_name: '伊藤') }
      let(:article_with_another_author) { create(:article, :with_author, author_name: '鈴木') }
      let(:article_with_tag) { create(:article, :with_tag, tag_name: 'Ruby') }
      let(:article_with_another_tag) { create(:article, :with_tag, tag_name: 'PHP') }
      let(:draft_article_with_sentence) { create(:article, :draft, :with_sentence, sentence_body: '基礎編') }
      let(:past_article_with_sentence) { create(:article, :past, :with_sentence, sentence_body: '基礎編') }
      let(:future_article_with_sentence) { create(:article, :future, :with_sentence, sentence_body: '基礎編') }
      let(:draft_article_with_another_sentence) { create(:article, :draft, :with_sentence, sentence_body: '応用編') }
      let(:past_article_with_another_sentence) { create(:article, :past, :with_sentence, sentence_body: '応用編') }
      let(:future_article_with_another_sentence) { create(:article, :future, :with_sentence, sentence_body: '応用編') }

      it '著者名で絞り込み検索ができること' do
        article_with_author
        article_with_another_author
        visit admin_articles_path
        select '伊藤', from: 'q[author_id]'
        click_button '検索'
        expect(page).to have_content(article_with_author.title)
        expect(page).not_to have_content(article_with_another_author.title)
      end

      it 'タグで絞り込みができること' do
        article_with_tag
        article_with_another_tag
        visit admin_articles_path
        select 'Ruby', from: 'q[tag_id]'
        click_button '検索'
        expect(page).to have_content(article_with_tag.title)
        expect(page).not_to have_content(article_with_another_tag.title)
      end

      it '公開状態の記事について、本文で絞り込み検索ができること' do
        visit edit_admin_article_path(past_article_with_sentence.uuid)
        click_on '公開する'
        visit edit_admin_article_path(past_article_with_another_sentence.uuid)
        click_on '公開する'
        visit admin_articles_path
        fill_in 'q[body]', with: '基礎'
        click_button '検索'
        expect(page).to have_content(past_article_with_sentence.title)
        expect(page).not_to have_content(past_article_with_another_sentence.title)
      end

      it '公開待ち状態の記事について、本文で絞り込み検索ができること' do
        visit edit_admin_article_path(future_article_with_sentence.uuid)
        click_on '公開する'
        visit edit_admin_article_path(future_article_with_another_sentence.uuid)
        click_on '公開する'
        visit admin_articles_path
        fill_in 'q[body]', with: '基礎'
        click_button '検索'
        expect(page).to have_content(future_article_with_sentence.title)
        expect(page).not_to have_content(future_article_with_another_sentence.title)
      end

      it '下書き状態の記事について、本文で絞り込み検索ができること' do
        draft_article_with_sentence
        draft_article_with_another_sentence
        visit admin_articles_path
        fill_in 'q[body]', with: '基礎'
        click_button '検索'
        expect(page).to have_content(draft_article_with_sentence.title)
        expect(page).not_to have_content(draft_article_with_another_sentence.title)
      end
    end
  end
end
