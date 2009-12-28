#!/usr/bin/env ruby

begin
  require 'rubygems'
  require 'httparty'
rescue LoadError
  puts "You must install HTTParty to use Gistsume: gem install httparty"
  exit
end

API_BASE_URI = "http://gist.github.com/api/v1/json/gists"
GIT_BASE_URI = "git://gist.github.com"

class Gistsume
  include HTTParty

  format :json

  def run(username)
    @username = username
    if @gists = get_gists_index
      process_gists
    else
      puts "#{username} doesn't exist."
    end
  end

  private

    def get_gists_index
      response = self.class.get("#{::API_BASE_URI}/#{@username}")
      response["gists"]
    end
  
    def process_gists
      if @gists.size == 0 
        puts "#{@username} doesn't have any gists."
        exit
      end
      
      @gists.each do |gist_data| 
        gist = Gist.new(gist_data, "#{@username}-gists")
        gist.clone_or_pull
      end
    end
end

class Gist
  def initialize(gist, root)
    @repo = gist["repo"]
    @description = gist["description"]
    @root = root
  end

  def clone_or_pull
    FileUtils.mkdir_p(@root)

    if File.directory?(directory)
      pull
    else
      clone
    end
  end

  private

    def directory
      "#{@root}/gist-#{@repo}"
    end

    def identifier
      "#{directory} #{description}"
    end

    def description
      "(#{@description})" if @description && @description.length > 0
    end

    def pull
      puts "Pulling #{identifier}"
      system "cd #{directory} && git pull --quiet 2>/dev/null"
    end

    def clone
      puts "Cloning #{identifier}"
      system "git clone --quiet #{::GIT_BASE_URI}/#{@repo}.git #{directory} 2>/dev/null"
    end
end

if ARGV.first
  Gistsume.new.run(ARGV.first)
else
  puts "Usage: gistsume.rb <username>"
  exit
end