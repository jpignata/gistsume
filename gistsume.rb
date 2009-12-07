#!/usr/bin/env ruby

begin
  require 'rubygems'
  require 'httparty'
rescue LoadError
  puts "You must install HTTParty to use Gistsume: gem install httparty"
  exit
end

class Gistsume
  CLONE_BASE_URI = "git://gist.github.com"
  API_BASE_URI = "http://gist.github.com/api/v1/json/gists"
  
  include HTTParty

  format :json
  
  class << self
    def run(username)
      @username = username
      get_gists_index
      create_gist_directory
      get_or_update_repositories
    end

    def get_gists_index
      response = get("#{API_BASE_URI}/#{@username}")
      if response.include?("gists")
        @gists = response["gists"]
      else
        puts "Gist index for #{@username} not found."
        exit
      end
    end

    def create_gist_directory
      Dir.mkdir(root_directory) unless File.directory?(root_directory)
    end
    
    def root_directory
      "#{@username}-gists"
    end
    
    def get_or_update_repositories
      @gists.each do |gist|
        if File.directory?(gist_directory(gist['repo']))
          pull_repository(gist)
        else
          clone_repository(gist)
        end
      end
    end

    def gist_directory(repo)
      "#{root_directory}/gist-#{repo}"
    end
    
    def gist_identifier(gist)
      "#{gist_directory(gist['repo'])} #{gist_description(gist['description'])}"
    end
    
    def gist_description(description)
      "(#{description})" if description && description.length > 0
    end
    
    def pull_repository(gist)
      puts "Pulling #{gist_identifier(gist)}"
      system "cd #{gist_directory(gist['repo'])} && git pull --quiet"
    end
    
    def clone_repository(gist)
      puts "Cloning #{gist_identifier(gist)}"
      system "git clone --quiet #{CLONE_BASE_URI}/#{gist['repo']}.git #{gist_directory(gist['repo'])}"
    end
  end
end

if ARGV[0]
  Gistsume.run(ARGV[0])
else
  puts "Usage: gitsume.rb <username>"
  exit
end