class Region < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :interval, presence: true
  has_many :histories, dependent: :destroy
  has_many :itches, dependent: :destroy
end
