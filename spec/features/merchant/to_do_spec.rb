require "rails_helper"
require "feature_helper"

RSpec.describe 'Merchant dashboard has To-Do list' do
  include FeatureHelper

  before(:each) do
    @merch = create(:user, role: 1)

    @item1 = create(:item, user: @merch, inventory: 1000)
    @item2 = create(:item, user: @merch, inventory: 1000)
    @item3 = create(:item, user: @merch, inventory: 1000)

    @todo_item1 = create(:item, user: @merch, image: nil)
    @todo_item2 = create(:item, user: @merch, image: nil)
    @todo_item3 = create(:item, user: @merch)

    @user = create(:user, role: 0)
    @order1 = create(:order, user: @user)
    @oitem1_1 = create(:order_item, order: @order1, item: @item1, quantity: 1)
    @oitem1_2 = create(:order_item, order: @order1, item: @item2, quantity: 2)

    @order2 = create(:order, user: @user)
    @oitem2_1 = create(:order_item, order: @order2, item: @item1, quantity: 1)
    @oitem2_2 = create(:order_item, order: @order2, item: @item2, quantity: 2)

    @order3 = create(:order, user: @user)
    @oitem3_1 = create(:order_item, order: @order3, item: @item1, quantity: 1)
    @oitem3_2 = create(:order_item, order: @order3, item: @item3, quantity: 2, fulfilled: true)

    @pending_count = (OrderItem.count - 1)
    @pending_revenue = OrderItem.where(fulfilled: false).sum('quantity * price')


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

      skip("I'm not sure if we item#show for a merchant user")
      # save_and_open_page

      card.click_link("#{@todo_item1.name}")
      # item GET    /items/:id(.:format) items#show
      path = item_path(id: @todo_item1)
      expect(page).to have_current_path(path)
    end
  end

  describe 'pending order items' do

    it 'displays order items yet to be fulfilled' do
      section = page.find('.pending-items')
      expect(section).to     have_content(@item1.name)
      expect(section).to     have_content(@item2.name)
      expect(section).to_not have_content(@item3.name)
      found = section.all('.pending-item').count
      expect(found).to eq(@pending_count)
    end

    it 'links to fulfill order item' do
      card = page.find("#pending-#{@oitem1_1.id}")
      card.click_button("Fulfill")
    end

    it "indicates if there's not enough stock to fulfill the item" do
      item = create(:item, user: @merch, inventory: 1)
      order = create(:order, user: @user)
      oitem = create(:order_item, order: order, item: item, quantity: 600)

      visit dashboard_path
      expect(page).to have_content(item.name)
      card = page.find("#pending-#{oitem.id}")
      expect(card).to have_content("Not enough inventory")
    end

    it 'has count of pending order items' do

      skip

      seciton = page.find('.pending-items-stats')
      expect(section).to have_content("Pending Count: #{@pending_count}")
    end

    it 'has total revenue impact of pending items' do

      skip

      seciton = page.find('.pending-items-stats')
      expect(section).to have_content("Pending Revenue: #{@pending_revenue}")
    end

  end















end
