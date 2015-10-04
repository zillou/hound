class OssTarget < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :oss_target_linters, dependent: :destroy
end
