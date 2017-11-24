class BookForm < Rectify::Form
  attribute :title, String
  attribute :description, String
  attribute :year, Integer
  attribute :height, Integer
  attribute :width, Integer
  attribute :thickness, Integer
  attribute :price, Decimal
  attribute :authors, Array[AuthorForm]
  attribute :materials, Array[MaterialForm]

  REGEXP = /\A([\p{Alnum}!#$%&'*+-\/=?^_`{|}~\s])+\z/

  validate :must_have_category, :must_have_authors, :must_have_materials

  validates :title,
            presence: true,
            format: { with: REGEXP, message: 'Invalid book title format' },
            length: { maximum: 80 }
  validates :description,
            presence: true,
            format: { with: REGEXP, message: 'Invalid book description format' },
            length: { maximum: 1000 }
  validates :year, numericality: {
    only_integer: true,
    greater_than: 1990,
    less_than_or_equal_to: Date.today.year
  }
  validates :height, numericality: {
    greater_than: 7,
    less_than: 16
  }
  validates :width, numericality: {
    greater_than: 3,
    less_than: 8
  }
  validates :thickness, numericality: {
    greater_than: 0,
    less_than: 4
  }
  validates :price, numericality: {
    greater_than_or_equal_to: 0.50,
    less_than_or_equal_to: 199.95
  }

  def must_have_category
    # errors.add(:base, 'Must have a category') if category.nil?
    # errors.add(:base, t('.activerecord.error.models.empty_category')) if category.nil?
    # errors.add(:base, I18n.t('.empty_category')) if category.nil?
    errors.add(:base, translate('.empty_category')) if category.nil?
  end

  def must_have_authors
    errors.add(:base, 'Must be at least one author') if authors.empty?
  end

  def must_have_materials
    errors.add(:base, 'Must be at least one material') if materials.empty?
  end

  private

  def translate(arg)
    I18n.t('.activerecord.errors.models.book' + arg)
  end
end