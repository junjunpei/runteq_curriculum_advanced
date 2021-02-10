require 'rails_helper'

RSpec.describe "AdminTags", type: :system do
  let(:admin_user) { create(:user, :admin) }
  let(:tag) { create(:tag) }
  before { login_as(admin_user) }

  context 'タグ一覧ページ' do
    it 'homeのパンくずが正常に作動する' do
      visit admin_tags_path
      expect(find('.breadcrumb')).to have_content 'Home'
      within('.breadcrumb') do
        click_link 'Home'
      end
      expect(current_path).to eq admin_dashboard_path
    end
  end

  context 'タグ編集ページ' do
    it 'タグのパンくずが正常に作動する' do
      visit edit_admin_tag_path(tag)
      expect(find('.breadcrumb')).to have_content('タグ')
      within('.breadcrumb') do
        click_link 'タグ'
      end
      expect(current_path).to eq admin_tags_path
    end
  end
end
