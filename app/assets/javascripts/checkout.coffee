$ ->
  $('#order_use_billing_address').change ->
    if @checked
      $('.shipping-hideable').addClass 'hidden'
    else
      $('.shipping-hideable').removeClass 'hidden'

  $('[data-toggle="tooltip"]').tooltip()

  setShipmentRadio = ->
    $("input:radio").each ->
      if $(@)[0].checked
        isXSRadio = @id.includes 'xs-', 0
        if $(document).width() < 768
          $("#xs-shipment-#{@id.split('-')[1]}")[0].checked = true unless isXSRadio
        else
          $("#shipment-#{@id.split('-')[2]}")[0].checked = true if isXSRadio
        false

  $(window).resize ->
    setShipmentRadio()

  $("input:radio").change ->
    shipmentPrice = parseFloat @getAttribute 'data-price'
    $('#shipment-label').text(I18n.l('currency', shipmentPrice))
    totalEl = $('#order-total-label')[0]
    subTotal = parseFloat totalEl.getAttribute 'data-subtotal'
    $(totalEl).text(I18n.l('currency', subTotal + shipmentPrice))
    $("input[name='shipment_price']").val(shipmentPrice)

  # $('#shipment-1')[0].click()
  setShipmentRadio()