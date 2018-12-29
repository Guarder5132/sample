class Micropost < ActiveRecord::Base
    #微博“属于(belongs_to)”用户
    belongs_to :user
    #通过default_scope设定微博的排序
    default_scope -> {order ('created_at DESC')} 
    #Micropost模型的数据验证
    validates :content, presence: true, length: {maximum: 140}
    #对微博user_id属性的验证
    validates :user_id, presence: true
end
