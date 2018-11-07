require "rails_helper"
require "feature_helper"

RSpec.describe 'Merchant dashboard has To-Do list' do

  before(:each) do
    @merch = create(:user, role: 1)

    @item1 = create(:item, user: @merch, inventory: 1000)
    @item2 = create(:item, user: @merch, inventory: 1000)
    @item3 = create(:item, user: @merch, inventory: 1000)

    @todo_item1 = create(:item, user: @merch, image: nil)
    @todo_item2 = create(:item, user: @merch, image: nil)
    @todo_item3 = create(:item, user: @merch)

    user = create(:user, role: 0)
    @order1 = create(:order, user: user)
    @oitem1_1 = create(:order_item, order: @order1, item: @item1, quantity: 1)
    @oitem1_2 = create(:order_item, order: @order1, item: @item2, quantity: 2)


    @order2 = create(:order, user: user)
    @oitem2_1 = reate(:order_item, order: @order2, item: @item1, quantity: 1)
    @oitem2_2 = reate(:order_item, order: @order2, item: @item2, quantity: 2)

    login(@merch)
    visit dashboard_path
  end

  describe 'items missing images' do

    it 'displays items missing images' do
      section = page.find('.missing-images')
      expect(section).to     have_content(@todo_item1.name)
      expect(section).to     have_content(@todo_item2.name)
      expect(section).to_not have_content(@todo_item3.name)
    end

    it 'links to item edit page' do
      card = page.find("#missing-#{@todo_item1.id}")
      card.click_link("Add an Image")
      # edit_merchant_item GET    /merchants/:merchant_id/items/:id/edit(.:format)
      path = edit_merchant_item_path(merchant_id: @merch.id, id: @todo_item1.id)
      expect(page).to have_current_path(path)
    end

    it 'links to item show page' do
      card = page.find("#missing-#{@todo_item1.id}")
      card.click_link("#{@todo_item1.name}")
      # item GET    /items/:id(.:format) items#show
      path = item_path(id: @todo_item1)
      expect(page).to have_current_path(path)
    end

  end















end
