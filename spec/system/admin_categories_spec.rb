require 'rails_helper'

RSpec.describe "AdminCategories", type: :system do
  let(:writer_user) { create(:user, :writer) }
  let!(:category) { create(:category) }

  describe 'カテゴリー一覧ページ' do
    it 'writerがアクセスした場合403エラー画面が表示される' do
      login_as(writer_user)
      visit admin_categories_path
      expect(page).to have_content('権限がありません。')
      expect(page).not_to have_content(category.name)
    end
  end
end
