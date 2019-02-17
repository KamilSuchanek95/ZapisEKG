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
    redirect_to :action => "index" if !params[:ciaramba] #jesli znajdziemy się tu bez danych do edycji
    redirect_to :action => "start", :alert =>"Brak uprawnień!" if !((User.find(session[:user_id])).admin?)#jezli nie mamy uprawnien

    if params[:ciaramba]
      @current_user = User.find(params[:ciaramba])

    end

    if params["edit"]
      data = {
          "first_name" => params["edit"]["first_name"],
          "last_name" => params["edit"]["last_name"],
          "pesel" => params["edit"]["pesel"],
          "role" => params["edit"]["role"]
      }
      @current_user = User.find_by id: params["edit"]["user_id"]

      if @current_user.update_attributes(data)
        #sleep 1.5
        flash[:success] = "Dokonano edycji!"
        #render 'edit' #redirect_to :action => "index"
      else
        #sleep 1.5
        flash[:error] = "Edycja zakończona niepowodzeniem!"
        #render 'edit'
      end
    end
  end


  private

  def edit_params
    params.require(:user).permit(:first_name, :last_name, :pesel, :role, :id)
  end

end