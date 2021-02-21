require 'rails_helper'

RSpec.describe "AdminAuthors", type: :system do
  let(:writer_user) { create(:user, :writer) }
  let!(:author) { create(:author) }

  describe '著者一覧ページ' do
    it 'writerがアクセスした場合403エラー画面が表示される' do
      login_as(writer_user)
      visit admin_authors_path
      expect(page).to have_content('権限がありません。')
      expect(page).not_to have_content(author.name)
    end
  end
end
