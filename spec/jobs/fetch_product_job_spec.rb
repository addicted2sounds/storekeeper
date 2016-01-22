require 'rails_helper'

RSpec.describe FetchProductJob, type: :job do
  let(:product) { Product.import url }

  before :each do
    stub_request(:get, url).to_return(status: 200, body: body)
  end

  subject { FetchProductJob.perform_now(product.id) }

  describe 'homedepot' do
    let!(:site) { create :site }
    let(:url) { 'http://www.homedepot.com/p/Rachael-Ray-Oval-Platter-in-Orange-53065/203083063' }
    let(:body) do
      file = Rails.root.join 'spec', 'support', 'fixtures', 'homedepot.html'
      File.read file
    end

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
             name: 'model_num', selector: '[itemprop="model"]', site: site
      is_expected.to include(model_num: '53065' )
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
      create :product_option, selector: '[itemprop="weight"]',
             name: 'weight', site: site
      is_expected.to include weight: '3.8 lb'
    end

    it 'extracts original price correctly' do
      create :product_option,
             selector: '"originalPrice":([\d.]+)',
             name: 'original_price', site: site, selector_type: :regexp
      is_expected.to include(original_price: '22.65')
    end

    it 'extracts special price correctly' do
      create :product_option,
             selector: '"specialPrice":([\d.]+)',
             name: 'special_price', site: site, selector_type: :regexp
      is_expected.to include(special_price: '22.65')
    end

    it 'extracts rating correctly' do
      create :product_option,
             selector: '"averageRating":"(.+?)"',
             name: 'rating', site: site, selector_type: :regexp
      is_expected.to include(rating: '0.0')
    end

    it 'extracts item availability correctly' do
      create :product_option,
             selector: '"itemAvailability":({.+?})',
             name: 'availability', site: site, selector_type: :regexp
      is_expected.to include(availability: '{"buyable":true,"availableOnlineStore":true,'\
      '"availableInStore":false,"inventoryStatus":true,"backorderable":false,'\
      '"published":true,"discontinuedItem":false}')
    end

    it 'extracts shipping weight correctly' do
      create :product_option,
             selector: '"Dotcom Shipping Carton Gross Weight \(lb\)","value":"(.*?)"',
             name: 'shipping_weight', site: site, selector_type: :regexp
      is_expected.to include shipping_weight: '3.8'
    end

    it 'extracts country of origin correctly' do
      create :product_option,
             selector: '"COUNTRY OF ORIGIN","value":"(.*?)"',
             name: 'country_of_origin', site: site, selector_type: :regexp
      is_expected.to include country_of_origin: 'CN'
    end

    it 'extracts if can ship to home correctly' do
      create :product_option,
             selector: '"shipToHome":{"status":(.*?)}',
             name: 'ship_to_home', site: site, selector_type: :regexp
      is_expected.to include ship_to_home: 'true'
    end

    it 'extracts upc correctly' do
      create :product_option,
             selector: '"upc":"(.+?)"',
             name: 'upc', site: site, selector_type: :regexp
      is_expected.to include(upc: '051153530654')
    end

    it 'sets nil if the property is not found' do
      create :product_option,
             selector: '//td/div[contains(.,"Not existing")]/following::td[1]/div',
             name: 'nonexisting', site: site, selector_type: :xpath
      is_expected.to include nonexisting: nil
    end
  end

  describe 'lowes' do
    let!(:site) { create :site, url: 'www.lowes.com' }
    let(:url) { 'http://www.lowes.com/pd_494086-74035-LWESCHATEAUEMP_1z0z33v__' }
    let(:body) do
      file = Rails.root.join 'spec', 'support', 'fixtures', 'lowes.html'
      File.read file
    end

    subject { FetchProductJob.perform_now(product.id) }
    it 'extracts title correctly' do
      create :product_option,
             name: 'title', selector: '.itemInfo h1', site: site
      is_expected.to include(title: 'American Olean Mosaic Chateau '\
      'Emperador Glazed Mixed Material (Stone and Glass) Mosaic Random Indoor/Outdoor'\
      ' Wall Tile (Common: 12-in x 12-in; Actual: 11.75-in x 13-in)' )
    end

    it 'extracts price correctly' do
      create :product_option,
             name: 'price', selector: '.mystore-item-price', site: site
      is_expected.to include price: nil
    end

    it 'extracts item_num correctly' do
      create :product_option,
             name: 'item_num', selector: '#ItemNumber', site: site
      is_expected.to include item_num: '494086'
    end

    it 'extracts model_num correctly' do
      create :product_option,
             name: 'item_num', selector: '#ModelNumber', site: site
      is_expected.to include item_num: 'LWESCHATEAUEMP'
    end

    it 'extracts rating correctly' do
      create :product_option,
             selector: '//*[@class="productRating"]/img/@alt',
             name: 'rating', site: site, selector_type: :xpath
      is_expected.to include rating: '4.84 / 5'
    end

    it 'extracts description correctly' do
      create :product_option,
             name: 'description', selector: '#description-tab', site: site
      is_expected.to have_key :description
    end

    it 'extracts specifications correctly' do
      create :product_option,
             name: 'specifications', selector: '#specifications-tab', site: site
      is_expected.to have_key :description
    end
  end
end
