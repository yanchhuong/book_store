feature 'Checkout complete page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit checkout_complete_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 3) }
    given!(:shipment) { create(:shipment) }

    background do
      page.set_rack_session(
        cart: { 1 => 1, 2 => 2, 3 => 3 },
        order: {
          billing: attributes_for(:address),
          shipping: attributes_for(:address, address_type: 'shipping'),
          shipment: attributes_for(:shipment),
          shipment_id: 1,
          card: attributes_for(:credit_card),
          subtotal: 5.4
        }
      )
      login_as(user, scope: :user)
      visit checkout_confirm_path
      click_on(t('checkout.confirm.place_order'))
    end

    scenario 'has 5 as current checkout progress step' do
      expect(page).to have_css('li.step.done', count: 4)
      expect(page).to have_css('li.step.active span.step-number', text: '5')
    end

    scenario 'has thanks message' do
      expect(page).to have_css(
        'h3.general-subtitle', text: t('checkout.complete.thanks')
      )
    end

    scenario 'has email sent message' do
      expect(page).to have_css(
        'p.font-weight-light', text: user.email
      )
    end

    scenario 'has order number set' do
      expect(page).to have_css('p.general-order-number', text: '#R00000001')
    end

    scenario 'has billing address' do
      expect(page).to have_css('p.general-address', text: 'Italy')
    end

    scenario 'has no address edit link' do
      expect(page).not_to have_link('edit', href: checkout_address_path)
    end

    scenario 'has books list' do
      expect(page).to have_css('p.general-title', count: 3)
      expect(page).to have_css(
        'p.general-title', text: books.first.title
      )
    end

    scenario 'has no input controls' do
      expect(page).to_not have_css('a.close.general-cart-close')
      expect(page).to_not have_css("input[type='text']")
      expect(page).to_not have_css('.quantity_increment')
      expect(page).to_not have_css('.quantity_decrement')
    end

    scenario 'has totals and shipment' do
      expect(page).to have_css('p.font-16', text: '5.40')
      expect(page).to have_css('p#shipment-label', text: '5.00')
      expect(page).to have_css('strong#order-total-label', text: '10.40')
    end

    scenario 'click back to store goes to catalog index' do
      click_on(t('checkout.complete.back_to_store'))
      expect(page).to have_css('h1', text: t('catalog.index.caption'))
    end
  end
end
