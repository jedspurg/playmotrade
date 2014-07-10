class Page < ActiveRecord::Base

  SITE_CATEGORIES = ['general', 'documentation', 'terms and service', 'blog']

  before_save :sanitize_slug

  belongs_to :page_category
  belongs_to :user

  validates :title, :slug, :body, :user, presence: true
  validates :slug, uniqueness: true
  validates :slug, exclusion: { in: %w(new edit create update), message: "<strong>%{value}</strong> is reserved." }

  scope :active, -> { where(active: true).order(:position)  }
  scope :site_pages, -> { where(:page_category_id => PageCategory.where(name: SITE_CATEGORIES).pluck(:id)).order(:position) }
  scope :grouped_by_category, -> { joins(:page_category).order(:page_category_id) }
  scope :by_page_category_id, lambda { |id| where(:page_category_id => id) }

  acts_as_list scope: :page_category_id

  def site_page?
    PageCategory.where(name: SITE_CATEGORIES).pluck(:id).include?(page_category_id)
  end

  private #####################################################################

  # before_save
  def sanitize_slug
    self.slug = slug.downcase.gsub(" ", "-")
  end
end
