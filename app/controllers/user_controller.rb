class UserController < ApplicationController

  def start

    if session[:user_id]

      @id = session[:user_id]

      user = User.find(@id)
      @first_name = user.first_name
      @last_name = user.last_name

    else
      redirect_to :action => "new"
    end

  end

  def new

    redirect_to :action => "start" if session[:user_id]

    if params["user"]

      data = {
          "first_name" => params["user"]["first_name"],
          "last_name" => params["user"]["last_name"],
          "password" => params["user"]["password"],
          "login" => params["user"]["login"],
          "pesel" => params["user"]["pesel"]
      }
      @save = User.new(data)

      if @save.save
      session[:user_id] = @save.id
      redirect_to :action => "start"
      end
    end

  end

  def remove
  end

  def login

    redirect_to :action => "start" if session[:user_id]
    if params["login"]
      if user = User.find_by_login(params["login"]["login"])
        password = Digest::SHA2.new << params["login"]["password"]
        if password == user.password
          session[:user_id] = user.id
          redirect_to :action => "start"
        end
      end
    end

  end

  def logout

    if session[:user_id]
      session[:user_id] = nil
      redirect_to :action => "login"
    end

  end

  def profile

    @user = User.find(params[:ciaramba])

    @signal = Przebiegi.where(user_id: @user.id).all

  end

  def index
    id = session[:user_id]
    user = User.find(id)
    if user.patient?
      redirect_to :action => "start", :alert =>"Brak uprawnień!"
    end
    @users = User.where.not(:id => id)


  end

  def edit

    if params[:ciaramba]
      @current_user = User.find(params[:ciaramba])
      @ciaramba = :ciaramba
    end

    if params["user"]

      data = {
          "first_name" => params["user"]["first_name"],
          "last_name" => params["user"]["last_name"],
          "pesel" => params["user"]["pesel"],
          "role" => params["user"]["role"]
      }

      @user = User.find(params["user"][:id])

      if @user.update_attributes(data)
        redirect_to :action => "index"
      else
        render 'edit'
      end
    end


  end

end