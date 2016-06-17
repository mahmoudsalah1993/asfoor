module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
	#gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
	if current_user.profile_picture?
		gravatar_url = current_user.profile_picture.url
	elsif (current_user.gender == "Male")
      gravatar_url = "/male_default.png"
    else
      gravatar_url = "/female_default.jpg"
    end
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end

