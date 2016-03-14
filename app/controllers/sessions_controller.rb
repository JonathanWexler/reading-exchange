class SessionsController < ApplicationController
    # require 'worldcat'
    def new

        # client = WorldCat.new ENV['WORLD_CAT_API']
        # atom = client.open_search :query => "Civil War"
        # puts atom.feed.title
        # puts atom.entries.first.author

        require 'amazon/ecs'
        Amazon::Ecs.configure do |options|
            options[:AWS_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
            options[:AWS_secret_key] = ENV['AWS_SECRET_ACCESS_KEY']
            options[:associate_tag] = 'test'
        end
        response = Amazon::Ecs.item_search('album mitch')
        # puts "HERE IS:::::: #{response} END::::::"
        # puts response.inspect
        @titles=[]
        response.items.each do |item|
          # retrieve string value using XML path
          item.get('ASIN')
          item.get('ItemAttributes/Title')

          # return Amazon::Element instance
          item_attributes = item.get_element('ItemAttributes')
          @titles.push item_attributes.get('Title')
      end

  end
  def create
    user = User.from_omniauth(env["omniauth.auth"]) 
    session[:user_id] = user.id
    redirect_to root_path
end

def destroy 
    session[:user_id] = nil 
    redirect_to root_path
end
end
