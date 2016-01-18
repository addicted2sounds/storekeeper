require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to validate_presence_of :site }
  it { is_expected.to validate_presence_of :path }

  describe '#import' do
    let!(:site) { create :site, url: 'www.homedepot.com' }
    let(:url) do
      'http://www.homedepot.com/p/Rachael-Ray-Oval-Platter-in-Orange-53065/203083063'
    end
    context 'valid url import' do

      it 'creates new product' do
        expect { Product.import(url) }.to change { Product.count }.by(1)
      end

      it 'set correct site for product' do
        product = Product.import(url)
        expect(product.site_id).to eq site.id
      end

      it 'returns product' do
        expect(Product.import(url)).to be_a Product
      end
    end

    context 'site is unknown' do
      let(:url) do
        'http://www.home.com/p/Rachael-Ray-Oval-Platter-in-Orange-53065/203083063'
      end

      it 'is not creating new product' do
        expect { Product.import(url) }.to change { Product.count }.by(0)
      end
    end
  end
end
