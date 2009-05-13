class CoresController < ApplicationController
  def show
      rev = Revision.find(param[:id])
      core = param[:corefile]
      corefile = "#{rev.builddir}/#{core}"
      if core !~ /^core\./ or not File.exists?(corefile)
          render :nothing => true, :status => 404
          return true
      end
      
      send_file corefile
  end

end
