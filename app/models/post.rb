class Post < ActiveRecord::Base

  before_create :slugify

  validates_uniqueness_of :slug

  private

  def slugify
    self.slug = self.title.parameterize('-')
  end

end
