class Page < ActiveRecord::Base

  before_save :sanitize_slug

  has_one :page_category
  belongs_to :user

  validates :title, :slug, :body, :user, presence: true

  private #####################################################################

  # before_save
  def sanitize_slug
    self.slug = slug.downcase.gsub(" ", "-")
  end
end
