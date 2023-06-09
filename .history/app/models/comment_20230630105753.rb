class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_rich_text :body
  has_rich_text :content
  has_one_attached :image
  has_many_attached :pictures
  after_create_commit :notify_recipient
  validates :body, presence: true, length:{minimum:7}
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification'

  def notify_recipient
    CommentNotification.with(comment: self, post: post).deliver_later(post.user)
  end

  def cleanup_notifications
    notifications_as_comment.destroy_all
  end
end
