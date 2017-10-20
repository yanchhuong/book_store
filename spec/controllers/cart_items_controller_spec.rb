describe CartItemsController do
  describe 'POST create' do
    before do
      create(:book_with_authors_and_materials)
      request.env['HTTP_REFERER'] = root_url
      post :create, params: { id: 1, quantity: 5 }
    end

    it 'adds new item to cart' do
      expect(session[:cart]['1']).to eq(5)
    end

    it 'redirects back to where the book was added to cart' do
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'DELETE destroy' do
    before do
      create_list(:book_with_authors_and_materials, 3)
      session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
      delete :destroy, params: { id: 3 }
    end

    it 'removes item from cart' do
      expect(session[:cart]['3']).to be_nil
    end

    it 'redirects back to cart' do
      expect(response).to redirect_to(cart_path)
    end
  end
end