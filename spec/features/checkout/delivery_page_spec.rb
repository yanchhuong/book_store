feature 'Checkout delivery page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit checkout_delivery_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    around do |example|
      login_as(create(:user), scope: :user)
      create_list(:book_with_authors_and_materials, 3)
      page.set_rack_session(
        cart: { 1 => 1, 2 => 2, 3 => 3 },
        items_total: 6.00,
        order_subtotal: 5.40
      )
      example.run
      page.set_rack_session(
        cart: nil, items_total: nil, order_subtotal: nil, order: nil
      )
    end

    context 'with no order addresses' do
      scenario 'redirects to checkout address step' do
        visit checkout_delivery_path
        expect(page).to have_css(
          'h3.general-subtitle', text: t('checkout.address.billing_address')
        )
      end
    end

    context 'with addresses set' do
      background do
        3.times { |n| create(:shipment, price: (n + 1) * 5.0) }
        page.set_rack_session(
          order: {
            billing: attributes_for(:address),
            items_total: 6.0,
            subtotal: 5.4
          }
        )
        visit checkout_delivery_path
      end

      scenario 'has 2 as current checkout progress step' do
        expect(page).to have_css('li.step.done')
        expect(page).to have_css('li.step.active span.step-number', text: '2')
      end

      scenario 'has shipment header' do
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('checkout.delivery.shipping_method')
        )
      end

      scenario 'has correct totals and shipment price' do
        expect(page).to have_css('p.font-16', text: '5.40')
        expect(page).to have_css('p#shipment-label', text: '5.00')
        expect(page).to have_css('strong#order-total-label', text: '10.40')
      end

      scenario 'click on radio button sets its shipment price' do
        all('span.radio-text')[1].click
        expect(page).to have_css('p#shipment-label', text: '10.00')
        expect(page).to have_css('strong#order-total-label', text: '15.40')
      end

      scenario 'click on save and continue goes to credit card step' do
        click_on(t('checkout.save_continue'))
        expect(page).to have_css(
          'h3.general-subtitle', text: t('checkout.payment.credit_card')
        )
      end
    end
  end
end