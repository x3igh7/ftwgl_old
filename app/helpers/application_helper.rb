module ApplicationHelper
  def avatar_url(user)
    default_url = asset_url("guest.png")
    if user.gravatar_email == ""
      return "guest.png"
    else
      gravatar_id = Digest::MD5::hexdigest(user.gravatar_email).downcase
      return "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    end
  end

  def big_avatar_url(user)
    default_url = asset_url("guest_big.png")
    unless user.nil?
      if user.gravatar_email == ""
        return "guest_big.png"
      else
        gravatar_id = Digest::MD5::hexdigest(user.gravatar_email).downcase
        return "http://gravatar.com/avatar/#{gravatar_id}.png?s=128&d=#{CGI.escape(default_url)}"
      end
    else
      return "guest_big.png"
    end
  end

  def team_avatar_url(team)
    default_url = asset_url("default_team.jpg")

    unless team.nil?
      if team.gravatar_email == ""
        return "default_team.jpg"
      else
        gravatar_id = Digest::MD5::hexdigest(team.gravatar_email).downcase
        return "http://gravatar.com/avatar/#{gravatar_id}.png?s=256&d=#{CGI.escape(default_url)}"
      end
    else
      return "default_team.jpg"
    end
  end

  def small_team_avatar_url(team)
    default_url = asset_url("default_team_small.jpg")

    unless team.nil?
      if team.gravatar_email == ""
        return "default_team_small.jpg"
      else
        gravatar_id = Digest::MD5::hexdigest(team.gravatar_email).downcase
        return "http://gravatar.com/avatar/#{gravatar_id}.png?s=32&d=#{CGI.escape(default_url)}"
      end
    else
      return "default_team_small.jpg"
    end
  end

  def youtube_url(youtube_channel)
    "https://www.youtube.com/user/#{youtube_channel}"
  end

  def twitch_url(twitch_channel)
    "http://www.twitch.tv/#{twitch_channel}"
  end

  def asset_url(asset)
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end
end
