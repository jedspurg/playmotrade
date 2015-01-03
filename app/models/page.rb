class Page < ActiveRecord::Base

  before_save :sanitize_slug

  belongs_to :page_category
  belongs_to :store

  validates :title, :slug, :body, presence: true
  validates :slug, uniqueness: { scope: :store }
  validates :slug, exclusion: { in: %w(new edit), message: "<strong>%{value}</strong> is reserved." }

  scope :active, -> { where(active: true).order(:position)  }
  scope :site_pages, -> { where('store_id IS NULL').order(:position) }
  scope :grouped_by_category, -> { joins(:page_category).order(:page_category_id) }
  scope :by_page_category_id, lambda { |id| where(:page_category_id => id) }
  scope :by_page_category_name, lambda { |name| where(:page_category_id => PageCategory.where(name: name).pluck(:id)).order(:position) }

  acts_as_list scope: :page_category_id

  def site_page?
    store.blank?
  end

  private #####################################################################

  # before_save
  def sanitize_slug
    self.slug = slug.downcase.gsub(" ", "-")
  end
end
