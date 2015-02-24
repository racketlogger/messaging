class LandingController < ApplicationController
  def index
  	@time = ['morning','afternoon','evening']
  	if params[:pid]
	  	if params[:toggle]
	  		preference = current_user.preferences.find(params[:pid])
	  		if preference.enable == 1
	  			preference_order = Preference.where(:text=>nil)
	  			preference_order.each do |f|
	  				if f.order < preference.order and f.enable==1
	  					f.order+=1
	  					f.save!
	  				end
	  			end
	  			preference.enable = 0
	  			preference.order = -1
	  		else
	  			preference_order = Preference.where(:text=>nil)
	  			preference_order.each do |f|
	  				if f.enable==1 and f.order==0
	  					f.order+=1
	  					f.save!
	  				end
	  			end
	  			preference_order_first = Preference.where(:text=>nil).order(:order)
	  			preference_order_first.each do |f|
	  				if f.order>0
	 					preference.enable = 1
	  					preference.order = f.order - 1
	  					break
	  				end
	  			end
	  		end
	  	preference.save!
	  	end

	  	if params[:op]
	  		preference = current_user.preferences.find(params[:pid])
	  		if params[:op].to_i==1
	  			select_preference = current_user.preferences.where(order: preference.order+1).first
	  			select_preference.order-=1 
	  			preference.order+=1
	  		else
	  			select_preference = current_user.preferences.where(order: preference.order-1).first
	  			select_preference.order+=1
	  			preference.order-=1
	  		end
	  		preference.save!
	  		select_preference.save!
	  	end
	  	redirect_to index_preferences_path
	  end

  	if current_user.preferences.exists?
    @preferences = current_user.preferences.where(:text=>nil).order(order: :desc)
    else
    Preference.create!(:name=>"WhatsApp",:order=>1,:enable=>1,:user_id=>current_user.id)
    Preference.create!(:name=>"Text Messages",:order=>2,:enable=>1,:user_id=>current_user.id)
    Preference.create!(:name=>"Email",:order=>3,:enable=>1,:user_id=>current_user.id)
    Preference.create!(:name=>"Phone Calls",:order=>0,:enable=>1,:user_id=>current_user.id)
    Preference.create!(:name=> "Saturday",:user_id=>current_user.id,:text=>"")
    Preference.create!(:name=> "Weekdays",:user_id=>current_user.id,:text=>"")
    Preference.create!(:name=> "Sunday",:user_id=>current_user.id,:text=>"")
    @preferences = current_user.preferences.where(:text=>nil).order(order: :desc)
  end
  	@weekdays = current_user.preferences.where(:name=>"Weekdays").first
	@weekdays = @weekdays.text.split(',')
	@saturday = current_user.preferences.where(:name=>"Saturday").first
	@saturday = @saturday.text.split(',')
	@sunday = current_user.preferences.where(:name=>"Sunday").first
	@sunday = @sunday.text.split(',')
  end
	respond_to do |format|
		format.html
		format.js
	end


def set_preferences
		# puts "Weekdays:  " + params[:wday_1].to_s + ","+ params[:wday_2].to_s + "," + params[:wday_3].to_s+ "================================================================================"
		preference1 = current_user.preferences.where(:name=>"Weekdays").first
		# puts preference.to_s + "11111111111111111111111111111111111111111111".to_s
		preference1.text = params[:wday_1].to_s + ","+ params[:wday_2].to_s + "," + params[:wday_3].to_s
		preference1.save!
		# puts "Saturday:  " + params[:stday_1].to_s + ","+ params[:stday_2].to_s + "," + params[:stday_3].to_s+ "==================================================================================================================================================================\n\n\n\n\n\n"
		preference2 = current_user.preferences.where(:name=>"Saturday").first
		# puts "8888888888888888888888888"
		preference2.text = params[:stday_1].to_s + ","+ params[:stday_2].to_s + "," + params[:stday_3].to_s
		# puts "66666666666666666666666666"
		preference2.save!
		# puts "Sunday:    " + params[:suday_1].to_s + ","+ params[:suday_2].to_s + "," + params[:suday_3].to_s+ "================================================================================"
		preference3 = current_user.preferences.where(:name=>"Sunday").first
		preference3.text = params[:suday_1].to_s + ","+ params[:suday_2].to_s + "," + params[:suday_3].to_s
		preference3.save!
		redirect_to index_preferences_path
end

end
