class StyleGuideConfig < ActiveRecord::Base
  belongs_to :owner

  validates :enabled, presence: true
  validates :name, presence: true
  validates :owner, presence: true
  validates :owner_id, uniqueness: { scope: :name }
end
