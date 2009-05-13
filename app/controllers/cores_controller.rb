class CoresController < ApplicationController
  def show
      rev = Revision.find(params[:id])
      core = params[:corefile]
      corefile = "#{rev.builddir}/#{core}"
      # these checks are important, because otherwise any arbitrary
      # file could be served out of your fs
      if core !~ /^core\.\d+$/ or not File.exists?(corefile)
          render :nothing => true, :status => 404
          return true
      end
      
      send_file corefile
  end

end
