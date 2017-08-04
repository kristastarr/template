# Show form to create new user
get '/users/new' do
  erb :'/users/register'
end


# Post new user registration form data
post '/users/new' do
  @user = User.create(params[:user])
  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else
    @error = @user.errors.full_messages
    erb :'/users/register'
  end
end

# Show user page
get '/users/:id' do
 erb :'/users/show'
end

# Get form to edit user details
get '/users/:id/edit' do
  if current_user
    @user = User.find(params[:id])
    erb :'users/edit_form'
  else
    @error = "Please log in!"
    erb :'/users/login'
  end
end

# Get user edit from data
put '/users/:id/edit' do
  @user = User.find(params[:id])
  @user.update_attributes(params[:user])
    if @user.save
      redirect "/users/#{@user.id}"
    else
      @error =  @user.errors.full_messages
      erb :'/users/edit_form'
    end
end


# Show user login form
get '/login' do
  erb :'/users/login'
end

# Post user login form data
post '/login' do
  @user = User.find_by(user_name: params[:user_name])
    if @user && @user.password == params[:password]
      session[:user_id] = @user.id
      redirect '/users/:id'
   else
      @error = "Your username and/or password is incorrect!"
      erb :'users/login'
  end
end


# Log out user
get '/logout' do
  session[:user_id] = nil
  redirect '/'
end


# Delete User
delete '/users/:id/delete' do
  @user = User.find(params[:id])
  @user.destroy
  redirect "/"
end

