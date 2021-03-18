require 'rails_helper'

RSpec.describe "ArticleMailers", type: :system do
  let(:mail) { ArticleMailer.report_summary }

  it '件名、宛先、送り主が正しいこと' do
    expect(mail.subject).to eq('公開済記事の集計結果')
    expect(mail.to).to eq(['admin@example.com'])
    expect(mail.from).to eq(['from@example.com'])
  end
end
