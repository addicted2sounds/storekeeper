require 'rails_helper'

RSpec.describe FetchProductJob, type: :job do
  describe 'homedepot' do
    let!(:site) { create :site }
    let(:url) { 'http://www.homedepot.com/p/Rachael-Ray-Oval-Platter-in-Orange-53065/203083063' }
    let(:product) { Product.import url }
    let(:body) do
      file = Rails.root.join 'spec', 'support', 'fixtures', 'homedepot.html'
      File.read file
    end

    before :each do
      stub_request(:get, url).to_return(status: 200, body: body)
    end

    subject { FetchProductJob.perform_now(product.id) }
    it 'extracts title correctly' do
      create :product_option,
             name: 'title', selector: '.product_title', site: site
      is_expected.to include(title: 'Oval Platter in Orange' )
    end

    it 'extracts price correctly' do
      create :product_option,
             name: 'price', selector: '[itemprop="price"]', site: site
      is_expected.to include(price: '$22.65')
    end

    it 'extracts model_num correctly' do
      create :product_option,
             name: 'model_num', selector: '.product_details.modelNo', site: site
      is_expected.to include(model_num: 'Model # 53065' )
    end

    it 'extracts brand correctly' do
      create :product_option,
             name: 'brand', selector: '[itemprop="brand"]', site: site
      is_expected.to include(brand: 'Rachael Ray')
    end

    it 'extracts description correctly' do
      create :product_option,
             name: 'description', selector: '[itemprop="description"]', site: site
      is_expected.to have_key :description
    end

    it 'extracts specifications correctly' do
      create :product_option,
             name: 'specifications', selector: '#specsContainer', site: site
      is_expected.to have_key :specifications
    end

    it 'extracts width correctly' do
      create :product_option,
             selector: '//td/div[contains(.,"Product Width")]/following::td[1]/div',
             name: 'width', site: site, selector_type: :xpath
      is_expected.to include(width: '12')
    end

    it 'extracts height correctly' do
      create :product_option,
             selector: '//td/div[contains(.,"Product Height")]/following::td[1]/div',
             name: 'height', site: site, selector_type: :xpath
      is_expected.to include(height: '3.75')
    end

    it 'extracts depth correctly' do
      create :product_option,
             selector: '//td/div[contains(.,"Product Depth")]/following::td[1]/div',
             name: 'depth', site: site, selector_type: :xpath
      is_expected.to include(depth: '16.25')
    end

    it 'extracts weight correctly' do
      create :product_option,
             selector: '//td/div[contains(.,"Product Weight")]/following::td[1]/div',
             name: 'weight', site: site, selector_type: :xpath
      is_expected.to include(weight: '3.8 lb')
    end

    it 'sets nil if the property is not found' do
      create :product_option,
             selector: '//td/div[contains(.,"Not existing")]/following::td[1]/div',
             name: 'nonexisting', site: site, selector_type: :xpath
      is_expected.to include nonexisting: nil
    end
  end
end
