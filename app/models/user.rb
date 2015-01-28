class User < ActiveRecord::Base
	  mount_uploader :image, AvatarUploader
end
