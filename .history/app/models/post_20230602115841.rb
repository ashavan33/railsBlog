class Post < ApplicationRecord
    validates :title, presence: true, length:{minimum:5, maximum:20}
    validates :body, presence: true, length:{minimum:10, maximum:200}
  belongs_to :user


end
