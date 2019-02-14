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

    @Messages = Message.find_by_receiver_id(@id)
    if @Messages
      @sender = User.find(@Messages.sender_id)
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

    @SIG = Przebiegi.where(user_id: @user.id).all

    if params[:REC]

      @signal = Przebiegi.find(params[:REC])
      @signal1 = @signal.zapis

    end


  end

  def index

    id = session[:user_id]
    user = User.find(id)
    if user.patient?
      redirect_to :action => "start", :alert =>"Brak uprawnień!"
    end
    @users = User.all

  end

  def edit

    redirect_to :action => "index" if !params[:ciaramba]

    id = session[:user_id]
    user = User.find(id)
    if !user.admin?
      redirect_to :action => "index", :alert =>"Brak uprawnień!"
    end

    if params[:ciaramba]
      @current_user = User.find(params[:ciaramba])
      @ciaramba = :ciaramba
    end

    if params["edit"]

      data = {
          "first_name" => params["edit"]["first_name"],
          "last_name" => params["edit"]["last_name"],
          "pesel" => params["edit"]["pesel"],
          "role" => params["edit"]["role"]
      }

      @user = User.find(params[:ciaramba])

      if @user.update_attributes(data)
        redirect_to :action => "index"
      else
        render 'edit'
      end
    end


  end

  def message

    redirect_to :action => 'profile' if !params[:ciaramba]


    @ciaramba = User.find(params[:ciaramba])


    if params["Message"]

      data = {
          "text" => params["Message"]["text"],
          "sender_id" => session[:user_id],
          "receiver_id" => params[:ciaramba]
      }

      @saveMessage = Message.new(data)

      if @saveMessage
        redirect_to user_profile_path(:ciaramba => params[:ciaramba])
      end

    end


end

end