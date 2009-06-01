class CoresController < ApplicationController
  def show
      test = TestRun.find(params[:id])
      core = params[:corefile]
      corefile = "#{test.builddir}/bin/#{core}"
      # these checks are important, because otherwise any arbitrary
      # file could be served out of your fs
      if core !~ /^core\.\d+$/ or not File.exists?(corefile)
          render :nothing => true, :status => 404
          return true
      end
      
      send_file corefile
  end

end
