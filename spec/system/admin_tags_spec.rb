require 'rails_helper'

RSpec.describe "AdminTags", type: :system do
  let(:admin_user) { create(:user, :admin) }
  let(:writer_user) { create(:user, :writer)}
  let!(:tag) { create(:tag) }

  describe 'タグ一覧ページ' do
    it 'Homeのパンくずが正常に作動する' do
      login_as(admin_user)
      visit admin_tags_path
      expect(find('.breadcrumb')).to have_content('Home')
      expect(find('.breadcrumb')).to have_content('タグ')
      within('.breadcrumb') do
        click_link 'Home'
      end
      expect(current_path).to eq(admin_dashboard_path)
    end

    it 'writerがアクセスした場合403エラー画面が表示される' do
      login_as(writer_user)
      visit admin_tags_path
      expect(page).to have_content('権限がありません。')
      expect(page).not_to have_content(tag.name)
    end
  end

  describe 'タグ編集ページ' do
    let(:tag) { create(:tag) }
    it 'タグのパンくずが正常に作動する' do
      login_as(admin_user)
      visit edit_admin_tag_path(tag)
      expect(find('.breadcrumb')).to have_content('Home')
      expect(find('.breadcrumb')).to have_content('タグ')
      expect(find('.breadcrumb')).to have_content('タグ編集')
      within('.breadcrumb') do
        click_link 'タグ'
      end
      expect(current_path).to eq(admin_tags_path)
    end
  end
end
