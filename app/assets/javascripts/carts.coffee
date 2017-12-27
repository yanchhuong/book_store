$ ->
  bsCartsModule = do ->
    init: ->
      $('.quantity-decrement').click (e) ->
        e.preventDefault()
        targetInput = $("##{@getAttribute 'data-target'}")[0]
        quantity = parseInt targetInput.value
        targetInput.value = quantity - 1 if quantity > 1
        $(targetInput).change()

      $('.quantity-increment').click (e) ->
        e.preventDefault()
        targetInput = $("##{@getAttribute 'data-target'}")[0]
        quantity = parseInt targetInput.value
        targetInput.value = quantity + 1
        $(targetInput).change()

      $('.quantity-input').change ->
        $("##{@getAttribute 'data-bound-input'}")[0].value = @value
        subtotal = I18n.l 'currency', calculateItemSubtotal @
        $(".#{@getAttribute 'data-bound-subtotal'}").each ->
          @textContent = subtotal
        setTotalsLabels(calculateItemsTotal(), calculateDiscount())

      calculateItemSubtotal = (el) ->
        subtotal = parseInt(el.value) * parseFloat(el.getAttribute 'data-price')
        if not subtotal? or isNaN(subtotal) then 0.0 else subtotal

      calculateItemsTotal = ->
        itemsTotal = 0.0
        $('.hidden-xs .quantity-input').each ->
          itemsTotal += calculateItemSubtotal @
        itemsTotal

      calculateDiscount = ->
        discount = parseFloat $('#items-total')[0].getAttribute('data-discount')
        if isNaN(discount) then 0.0 else discount / 100

      toCurrency = (val) ->
        I18n.l 'currency', val

      setTotalsLabels = (itemsTotal, discount) ->
        $('#items-total')[0].textContent = toCurrency itemsTotal
        cut = itemsTotal * discount
        $('#discount')[0].textContent = toCurrency cut
        $('#order-subtotal')[0].textContent = toCurrency(itemsTotal - cut)

  bsCartsModule.init()

