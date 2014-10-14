module ApplicationHelper
  def avatar_url(user)
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5::hexdigest(user.gravatar_email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  def big_avatar_url(user)
    default_url = "#{root_url}images/guest_big.png"
    gravatar_id = Digest::MD5::hexdigest(user.gravatar_email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=128&d=#{CGI.escape(default_url)}"
  end

  def team_avatar_url(team)
    default_url = "#{root_url}images/default_team.jpg"

    if team.gravatar_email.nil?
      return "default_team.jpg"
    else
      gravatar_id = Digest::MD5::hexdigest(team.gravatar_email).downcase
      return "http://gravatar.com/avatar/#{gravatar_id}.png?s=256&d=#{CGI.escape(default_url)}"
    end
  end

  def youtube_url(youtube_channel)
    "https://www.youtube.com/user/#{youtube_channel}"
  end

  def twitch_url(twitch_channel)
    "http://www.twitch.tv/#{twitch_channel}"
  end

  def youtube_video(featured_video)
    render :partial => 'youtube_video_embed', :locals => { :youtube_url => featured_video }
  end
end
