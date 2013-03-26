#!/bin/env ruby
#encoding: utf-8

require 'spec_helper'

describe UsersController do
	render_views
	
	describe "GET 'index'" do

    describe "pour utilisateur non identifiés" do
      it "devrait refuser l'accès" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign/i
      end
    end #utilisateur non identifié

    describe "pour un utilisateur identifié" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")

        @users = [@user, second, third]
      end

      it "devrait réussir" do
        get :index
        response.should be_success
      end

      it "devrait avoir le bon titre" do
        get :index
        response.should have_selector("title", :content => "Liste des utilisateurs")
      end

      it "devrait avoir un élément pour chaque utilisateur" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content => user.nom)
        end
      end 
    end  #utilisateur identifié
	end #describe index

	describe "GET 'show'" do

		before(:each) do
			@user = Factory(:user)
		end

		it "devrait réussir" do
			get :show, :id => @user
			response.should be_success
		end

		it "devrait trouver le bon utilisateur" do
			get :show, :id => @user
			assigns(:user).should == @user
		end
		
		it "devrait avoir le bon titre" do
      	get :show, :id => @user
      	response.should have_selector("title", :content => @user.nom)
    	end

    	it "devrait inclure le nom de l'utilisateur" do
      	get :show, :id => @user
      	response.should have_selector("h1", :content => @user.nom)
    	end

    	it "devrait avoir une image de profil" do
      	get :show, :id => @user
      	response.should have_selector("h1>img", :class => "gravatar")
    	end
	end #describe GET show

   describe "GET 'new'" do
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the title 'Inscription'" do
      get 'new'
      response.should have_selector("title", :content => "Inscription")
    end
  end #describe GET new
  
  describe "POST 'create'" do

    describe "échec" do

      before(:each) do
        @attr = { :nom => "", :email => "", :password => "",
                  :password_confirmation => "",:poids => nil, :poids_ideal => nil,
                  :date => "", :taille => nil}
      end

      it "ne devrait pas créer d'utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "devrait avoir le bon titre" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Inscription")
      end

      it "devrait rendre la page 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end #describe echec
    
    describe "succès" do

      before(:each) do
        @attr = { :nom => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar", :poids => 80, :poids_ideal => 70,
                  :date => "1989-12-12", :taille => 175}
      end

      it "devrait créer un utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

		it "devrait identifier l'utilisateur" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "devrait avoir un message de bienvenue" do
        post :create, :user => @attr
        flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
      end
      it "devrait avoir un message de bienvenue" do
        post :create, :user => @attr
        flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
      end
    end #describe succes
  end #describe create
  
  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "devrait réussir" do
      get :edit, :id => @user
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Édition profil")
    end

    it "devrait avoir un lien pour changer l'image Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "changer")
    end
  end #describe edit
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "Échec" do

      before(:each) do
        @attr = { :email => "", :nom => "", :password => "",
                  :password_confirmation => "" }
      end

      it "devrait retourner la page d'édition" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "devrait avoir le bon titre" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Édition profil")
      end
    end # Echec update

    describe "succès" do

      before(:each) do
        @attr = { :nom => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "devrait modifier les caractéristiques de l'utilisateur" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.nom.should  == @attr[:nom]
        @user.email.should == @attr[:email]
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "devrait afficher un message flash" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /actualisé/
      end
    end # succes update
  end #update
  
  describe "authentification des pages edit/update" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "pour un utilisateur non identifié" do

      it "devrait refuser l'acccès à l'action 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "devrait refuser l'accès à l'action 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end #utilisateur non identifié
    
    describe "pour un utilisateur identifié" do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "devrait correspondre à l'utilisateur à éditer" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "devrait correspondre à l'utilisateur à actualiser" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end #utilisateur identifié
  end #authentification des pages
  
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "en tant qu'utilisateur non identifié" do
      it "devrait refuser l'accès" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end # en tant qu'utilisateur non identifié

    describe "en tant qu'utilisateur non administrateur" do
      it "devrait protéger la page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end # en tant que non admin

    describe "en tant qu'administrateur" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "devrait détruire l'utilisateur" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "devrait rediriger vers la page des utilisateurs" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end # en tant qu'administrateur
  end # DELETE destroy
  
end
