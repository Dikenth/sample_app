#!/bin/env ruby
#encoding: utf-8

require 'spec_helper'

describe "Users" do

  describe "Une inscription" do

    describe "ratée" do

      it "ne devrait pas créer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in :user_nom , :with => ""
			  fill_in :user_email , :with => ""
			  fill_in :user_password , :with => ""
			  fill_in :user_password_confirmation , :with => ""
			  fill_in :user_poids , :with => "" 
			  fill_in :user_poids_ideal , :with => ""
			  fill_in :user_taille , :with => ""
			  fill_in :user_fumeur , :with => ""
			  fill_in :user_aret , :with => ""
			  fill_in :user_date , :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "réussie" do

      it "devrait créer un nouvel utilisateurr" do
        lambda do
          visit signup_path
           fill_in :user_nom , :with =>         "Michael Hartl"
			  fill_in :user_email , :with =>          "mhartl@example.com"
			  fill_in :user_password , :with =>          "foobar"
			  fill_in :user_password_confirmation , :with => "foobar"
			  fill_in :user_poids , :with => 60 
			  fill_in :user_poids_ideal , :with => 52
			  fill_in :user_taille , :with => 175
			  fill_in :user_fumeur , :with => true
			  fill_in :user_aret , :with => false
			  fill_in :user_date , :with => "1989-12-12"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
    
    describe "identification/déconnexion" do

    describe "l'échec" do
      it "ne devrait pas identifier l'utilisateur" do
        visit signin_path
        fill_in "eMail",    :with => ""
        fill_in "Mot de passe", :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Combinaison Email/Mot de passe invalide.")
      end
    end

    describe "le succès" do
      it "devrait identifier un utilisateur puis le déconnecter" do
        user = Factory(:user)
        visit signin_path
        fill_in "eMail",    :with => user.email
        fill_in "Mot de passe", :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Déconnexion"
        controller.should_not be_signed_in
      end
    end
    end
  end
end
