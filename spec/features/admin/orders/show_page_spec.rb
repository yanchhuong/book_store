feature 'Admin show Order page' do
  include_examples 'not authorized', :admin_order_path, 1

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 4) }
    given(:credit_card) { create(:credit_card) }
    given!(:order) do
      create(:order,
             user: admin_user,
             shipment: build(:shipment, price: 12.99),
             addresses: [
               build(:address),
               build(:address, address_type: 'shipping', country: 'Chad')
             ],
             order_items: build_list(:order_item_with_book_id_cycled, 4),
             credit_card: credit_card,
             coupon: build(:coupon),
             subtotal: 35.16)
    end

    background do
      login_as(admin_user, scope: :user)
    end

    context 'order details' do
      scenario 'shows order details' do
        visit admin_order_path(order)
        expect(page).to have_link(admin_user.email)
        books.map(&:title) + [4.00, '10%', 12.99, 35.16, 48.15] + [
          t('checkout.address.billing_address'),
          'Italy',
          t('checkout.address.shipping_address'),
          'Chad',
          t('checkout.payment.credit_card'),
          credit_card.number.scan(/(....)/).join(' ')
        ].each { |text| expect(page).to have_text(text) }
      end
    end

    context 'aasm actions' do
      include_context 'aasm prefixes'
      include_context 'aasm order variables'

      params = AASMHelper.order_config.merge(
        set: AASMHelper.order_state_events_set,
        path_helper: :admin_order_path,
        resource_path: true
      )

      include_examples 'aasm actions', params do
        given(:entity) { order }
      end
    end
  end
end
