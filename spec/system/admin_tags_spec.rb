require 'rails_helper'

RSpec.describe "AdminTags", type: :system do
  let(:admin_user) { create(:user, :admin) }
  before do
    login_as(admin_user)
  end

  describe 'タグ一覧ページ' do
    it 'Homeのパンくずが正常に作動する' do
      visit admin_tags_path
      expect(find('.breadcrumb')).to have_content('Home')
      expect(find('.breadcrumb')).to have_content('タグ')
      within('.breadcrumb') do
        click_link 'Home'
      end
      expect(current_path).to eq(admin_dashboard_path)
    end
  end

  describe 'タグ編集ページ' do
    let(:tag) { create(:tag) }
    it 'タグのパンくずが正常に作動する' do
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
