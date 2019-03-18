class Api::PagesController < ApplicationController
  def spotify_authorize
    redirect_to "https://accounts.spotify.com/authorize?client_id=#{ENV['SPOTIFY_CLIENT_ID']}&response_type=code&redirect_uri=http://localhost:3000/api/spotify/callback"
  end

  def spotify_callback
    code = params[:code]

    response = HTTP.post(
                          "https://accounts.spotify.com/api/token", 
                          form: {
                                 grant_type: "authorization_code",
                                 code: code,
                                 redirect_uri: "http://localhost:3000/api/spotify/callback",
                                 client_id: ENV['SPOTIFY_CLIENT_ID'],
                                 client_secret: ENV['SPOTIFY_CLIENT_SECRET']
                                }
                          )


    access_token = response.parse["access_token"]

    response_2 = HTTP
            .auth("Bearer #{access_token}")
            .get("https://api.spotify.com/v1/me")

    render json: response_2.parse
  end
end










