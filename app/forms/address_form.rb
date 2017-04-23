class AddressForm < Rectify::Form
  fields = {
    first_name: /\A[A-Za-z]{,50}\z/,
    last_name: /\A[A-Za-z]{,50}\z/,
    address: /\A[A-Za-z0-9 ,-]{,50}\z/,
    city: /\A[A-Za-z]{,50}\z/,
    zip: /\A[0-9-]{3,10}\z/,
    phone: /\A\+\d{5,15}\z/
  }

  fields.each do |field, format|
    attribute field, String
    humanized = field.to_s.humanize(capitalize: false)
    validates field,
              presence: { message: "Please enter your #{humanized}" },
              format: { with: format, message: "Invalid #{humanized} format" }
  end

  attribute :country, String
end
