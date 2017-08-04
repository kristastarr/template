get '/photos' do
  erb :photos
end

## from instagram ruby gem website
get "/" do
  '<a href="/oauth/connect">Connect with Instagram</a>'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/nav"
end



get "/user_recent_media" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user
  html = "<h1>#{user.username}'s recent media</h1>"
  for media_item in client.user_recent_media
    html << "<div style='float:left;'><img src='#{media_item.images.thumbnail.url}'><br/> <a href='/media_like/#{media_item.id}'>Like</a>  <a href='/media_unlike/#{media_item.id}'>Un-Like</a>  <br/>LikesCount=#{media_item.likes[:count]}</div>"
  end
  html
end


get "/user_media_feed" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user
  html = "<h1>#{user.username}'s media feed</h1>"

  page_1 = client.user_media_feed(777)
  page_2_max_id = page_1.pagination.next_max_id
  page_2 = client.user_recent_media(777, :max_id => page_2_max_id ) unless page_2_max_id.nil?
  html << "<h2>Page 1</h2><br/>"
  for media_item in page_1
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html << "<h2>Page 2</h2><br/>"
  for media_item in page_2
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end

