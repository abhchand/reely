require 'rails_helper'

RSpec.describe 'shared/_breadcrumb_heading.html.erb', type: :view do
  let(:breadcrumbs) do
    [
      { label: 'One', href: '/one' },
      { label: 'Two', href: '/two' },
      { label: 'Three', href: nil }
    ]
  end

  it 'renders crumbs with links' do
    actual = []
    expected = breadcrumbs[0..1]

    render_partial

    page.all('.breadcrumb-heading h3 a').each do |el|
      actual << { label: el.text, href: el['href'] }
    end

    expect(actual).to eq(expected)
  end

  it 'renderst the last item as the current page heading' do
    render_partial

    expect(page.find('.breadcrumb-heading h1')).to have_content('Three')
  end

  def render_partial
    render(
      partial: 'shared/breadcrumb_heading', locals: { breadcrumbs: breadcrumbs }
    )
  end
end
