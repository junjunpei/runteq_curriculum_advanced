require 'rails_helper'

RSpec.describe "AdminPolicies", type: :system do
  let(:writer_user) { create(:user, :writer) }
  let(:editor_user) { create(:user, :editor) }
  let(:admin_user)       { create(:user, :admin) }
  let!(:category)   { create :category }
  let!(:tag)        { create :tag }
  let!(:author)      { create :author }

  before do
    driven_by(:rack_test)
  end

  describe 'ライターのアクセス権限' do
    before do
      login_as(writer_user)
      visit admin_dashboard_path
    end

    context 'ダッシュボードページにアクセス' do
      it 'カテゴリーページのリンクが表示されていないこと' do
        expect(page).not_to have_link('カテゴリ')
      end

      it 'タグページのリンクが表示されていないこと' do
        expect(page).not_to have_link('タグ')
      end

      it '著者ページのリンクが表示されていない' do
        expect(page).not_to have_link('著者')
      end
    end

    context 'カテゴリー一覧ページにアクセス' do
      it 'アクセスが失敗となり、403エラーが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(403)
        expect(page).not_to have_content(category.name)
      end
    end

    context 'カテゴリー編集ページにアクセス' do
      it 'アクセスが失敗となり、403エラーが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(403)
        expect(page).not_to have_selector("input[value=#{category.name}]")
      end
    end

    context 'タグ一覧ページにアクセス' do
      it 'アクセスが失敗となり、403エラーが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(403)
        expect(page).not_to have_content(tag.name)
      end
    end

    context 'タグ編集ページにアクセス' do
      it 'アクセスが失敗となり、403エラーが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(403)
        expect(page).not_to have_selector("input[value=#{tag.name}]")
      end
    end

    context '著者一覧ページにアクセス' do
      it 'アクセスが失敗となり、403エラーが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(403)
        expect(page).not_to have_content(author.name)
      end
    end

    context '著者編集ページにアクセス' do
      it 'アクセスが失敗となり、403エラーが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(403)
        expect(page).not_to have_selector("input[value=#{author.name}]")
      end
    end
  end

  describe '編集者のアクセス権限' do
    before do
      login_as(editor_user)
      visit admin_dashboard_path
    end

    context 'ダッシュボードページにアクセス' do
      it 'カテゴリーページのリンクが表示されること' do
        expect(page).to have_link('カテゴリー')
      end

      it 'タグページのリンクが表示されること' do
        expect(page).to have_link('タグ')
      end

      it '著者ページのリンクが表示されること' do
        expect(page).to have_link('著者')
      end
    end

    context 'カテゴリー一覧ページにアクセス' do
      it 'アクセスが成功となり、カテゴリー一覧ページが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(category.name)
      end
    end

    context 'カテゴリー編集ページにアクセス' do
      it 'アクセスが成功となり、カテゴリー編集ページが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{category.name}]")
      end
    end

    context 'タグ一覧ページにアクセス' do
      it 'アクセスが成功となり、タグ一覧ページが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(tag.name)
      end
    end

    context 'タグ編集ページにアクセス' do
      it 'アクセスが成功となり、タグ編集ページが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{tag.name}]")
      end
    end

    context '著者一覧ページにアクセス' do
      it 'アクセスが成功となり、著者一覧ページが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(author.name)
      end
    end

    context '著者編集ページにアクセス' do
      it 'アクセスが成功となり、著者編集ページが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{author.name}]")
      end
    end
  end

  describe '管理者のアクセス権限' do
    before do
      login_as(admin_user)
      visit admin_dashboard_path
    end

    context 'ダッシュボードページにアクセス' do
      it 'カテゴリーページのリンクが表示されること' do
        expect(page).to have_link('カテゴリー')
      end

      it 'タグページのリンクが表示されること' do
        expect(page).to have_link('タグ')
      end

      it '著者ページのリンクが表示されること' do
        expect(page).to have_link('著者')
      end
    end

    context 'カテゴリー一覧ページにアクセス' do
      it 'アクセスが成功となり、カテゴリー一覧ページが表示されること' do
        visit admin_categories_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(category.name)
      end
    end

    context 'カテゴリー編集ページにアクセス' do
      it 'アクセスが成功となり、カテゴリー編集ページが表示されること' do
        visit edit_admin_category_path(category)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{category.name}]")
      end
    end

    context 'タグ一覧ページにアクセス' do
      it 'アクセスが成功となり、タグ一覧ページが表示されること' do
        visit admin_tags_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(tag.name)
      end
    end

    context 'タグ編集ページにアクセス' do
      it 'アクセスが成功となり、タグ編集ページが表示されること' do
        visit edit_admin_tag_path(tag)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{tag.name}]")
      end
    end

    context '著者一覧ページにアクセス' do
      it 'アクセスが成功となり、著者一覧ページが表示されること' do
        visit admin_authors_path
        expect(page).to have_http_status(200)
        expect(page).to have_content(author.name)
      end
    end

    context '著者編集ページにアクセス' do
      it 'アクセスが成功となり、著者編集ページが表示されること' do
        visit edit_admin_author_path(author)
        expect(page).to have_http_status(200)
        expect(page).to have_selector("input[value=#{author.name}]")
      end
    end
  end
end
