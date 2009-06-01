module TestrunsHelper
    def list_cores(test)
        cores = []
        if File.directory? test.builddir
            Dir.foreach "#{test.builddir}/bin" do |f|
                if f =~ /^core.\d+/
                    cores << f
                end
            end
        end
        return cores
    end
end
