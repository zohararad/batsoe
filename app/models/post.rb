class Post < ActiveRecord::Base

  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper

  before_create :slugify

  validates_uniqueness_of :slug

  def excerpt
    str = strip_tags(self.body)
    truncate(str, length: 200, omission: '...')
  end

  private

  def slugify
    self.slug = self.title.parameterize('-')
  end

end
