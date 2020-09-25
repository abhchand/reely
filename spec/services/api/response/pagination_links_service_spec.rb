require 'rails_helper'

RSpec.describe Api::Response::PaginationLinksService do
  let(:data) { [1, 2, 3, 4, 5] }

  before { stub_default_page_size(2) }

  describe '#next_url' do
    it 'returns the URL for page 2' do
      @url = 'https://api.example.com/api/users'
      expected = 'https://api.example.com/api/users?page=2'

      expect(service.next_url).to eq(expected)
    end

    it 'preserves the other query params' do
      @url = 'https://api.example.com/api/users?foo=bar'
      expected = 'https://api.example.com/api/users?foo=bar&page=2'

      expect(service.next_url).to eq(expected)
    end

    context 'data set is empty' do
      let(:data) { [] }

      it 'returns nil' do
        @url = 'https://api.example.com/api/users'
        expect(service.next_url).to be_nil
      end
    end

    context 'last page is 1' do
      before { stub_default_page_size(5) }

      it 'returns nil' do
        @url = 'https://api.example.com/api/users'
        expect(service.next_url).to be_nil
      end
    end

    context '`page` param is specified' do
      it 'returns the next page url' do
        @url = 'https://api.example.com/api/users?page=2'
        expected = 'https://api.example.com/api/users?page=3'

        expect(service.next_url).to eq(expected)
      end

      it 'preserves the other query params' do
        @url = 'https://api.example.com/api/users?foo=bar&page=2&x=y'
        expected = 'https://api.example.com/api/users?foo=bar&page=3&x=y'

        expect(service.next_url).to eq(expected)
      end

      it 'works with `per_page' do
        @url = 'https://api.example.com/api/users?page=2&per_page=1'
        expected = 'https://api.example.com/api/users?page=3&per_page=1'

        expect(service.next_url).to eq(expected)
      end
    end

    context 'current URL is for the last page' do
      it 'returns nil' do
        @url = 'https://api.example.com/api/users?page=3'
        expect(service.next_url).to be_nil
      end
    end

    context 'current URL is for beyond the last page' do
      it 'returns nil' do
        @url = 'https://api.example.com/api/users?page=4'
        expect(service.next_url).to be_nil
      end
    end

    context '`per_page` is out of bounds' do
      it 'defaults to PAGE_SIZE when `per_page` > PAGE_SIZE' do
        @url = 'https://api.example.com/api/users?per_page=3'
        expected = 'https://api.example.com/api/users?page=2&per_page=2'

        expect(service.next_url).to eq(expected)
      end

      it 'defaults to 1 when `per_page` < 1' do
        @url = 'https://api.example.com/api/users?per_page=0'
        expected = 'https://api.example.com/api/users?page=2&per_page=2'

        expect(service.next_url).to eq(expected)
      end
    end
  end

  describe '#last_url' do
    it 'returns the last page url' do
      @url = 'https://api.example.com/api/users'
      expected = 'https://api.example.com/api/users?page=3'

      expect(service.last_url).to eq(expected)
    end

    it 'preserves the other query params' do
      @url = 'https://api.example.com/api/users?foo=bar'
      expected = 'https://api.example.com/api/users?foo=bar&page=3'

      expect(service.last_url).to eq(expected)
    end

    context 'data set is empty' do
      let(:data) { [] }

      it 'returns nil' do
        @url = 'https://api.example.com/api/users'
        expect(service.last_url).to be_nil
      end
    end

    context 'last page is 1' do
      before { stub_default_page_size(5) }

      it 'returns the last page url' do
        @url = 'https://api.example.com/api/users'
        expected = 'https://api.example.com/api/users?page=1'

        expect(service.last_url).to eq(expected)
      end
    end

    context '`page` param is specified' do
      it 'returns the last page url' do
        @url = 'https://api.example.com/api/users?page=1'
        expected = 'https://api.example.com/api/users?page=3'

        expect(service.last_url).to eq(expected)
      end

      it 'preserves the other query params' do
        @url = 'https://api.example.com/api/users?foo=bar&page=1&x=y'
        expected = 'https://api.example.com/api/users?foo=bar&page=3&x=y'

        expect(service.last_url).to eq(expected)
      end

      it 'works with `per_page' do
        @url = 'https://api.example.com/api/users?page=1&per_page=1'
        expected = 'https://api.example.com/api/users?page=5&per_page=1'

        expect(service.last_url).to eq(expected)
      end
    end

    context '`per_page` is out of bounds' do
      it 'defaults to PAGE_SIZE when `per_page` > PAGE_SIZE' do
        @url = 'https://api.example.com/api/users?per_page=3'
        expected = 'https://api.example.com/api/users?page=3&per_page=2'

        expect(service.last_url).to eq(expected)
      end

      it 'defaults to PAGE_SIZE when `per_page` < 1' do
        @url = 'https://api.example.com/api/users?per_page=0'
        expected = 'https://api.example.com/api/users?page=3&per_page=2'

        expect(service.last_url).to eq(expected)
      end
    end
  end

  def stub_default_page_size(size)
    stub_const('Api::Response::PaginationLinksService::PAGE_SIZE', size)
  end

  def service(url = @url)
    uri = URI.parse(url)

    params =
      if uri.query
        Hash[uri.query.split('&').map { |p| p.split('=') }]
          .with_indifferent_access
      else
        {}
      end

    Api::Response::PaginationLinksService.new(data, url, params)
  end
end
