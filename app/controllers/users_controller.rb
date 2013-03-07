class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @titre = @user.nom
  end
  
  def new
  	@user = User.new
  	@titre = "Inscription"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
    	sign_in @user
    	flash[:success] = "Bienvenue dans l'Application Exemple!"
    	redirect_to @user
      # Traite un succès d'enregistrement.
    else
      @titre = "Inscription"
      render 'new'
    end
  end
  
	def uploadFile
    post = User.save_cv(params[:upload], params[:id].keys)
    @user = User.find(params[:id].keys)
    redirect_to @user
  end
end
