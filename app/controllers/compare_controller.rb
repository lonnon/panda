class CompareController < ApplicationController
    require "open-uri"
    
    
    def buildtimes
        @hosts = Host.find(:all)
        @charts = []
        @hosts.each do |host|
            @charts << open_flash_chart_object(1000, 500, url_for(:action => "external", :id => host), true, "#{relative_url_root}/") 
        end
    end
    
    def external
        host = Host.find(params[:id])
        
        @url = "http://#{host.hostname}#{host.root}/graph/graph_code"
        response =  ""
        open(@url) do |f|
            response = f.read
        end
        
        render :content_type => :json, :text => response
    end
end
