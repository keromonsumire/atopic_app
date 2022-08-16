class Region < ApplicationRecord
    belongs_to :user
    has_many :historys
end
