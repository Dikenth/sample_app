#!/bin/env ruby
#encoding: utf-8

require 'faker'

namespace :db do
  desc "Peupler la base de données"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    administrateur = User.create!(:nom => "Utilisateur exemple",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar",
                 :poids => 75,
                 :poids_ideal => 68,
                 :taille => 175,
                 :fumeur => true,
                 :aret => false,
                 :date => "1989-12-12")
    administrateur.toggle!(:admin)
    
    99.times do |n|
      nom  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "motdepasse"
      User.create!(:nom => nom,
                   :email => email,
                   :password => password,
                   :password_confirmation => password,
                   :poids => 75,
				       :poids_ideal => 68,
				       :taille => 175,
				       :fumeur => true,
				       :aret => false,
				       :date => "1989-12-12")
    end
  end
end
