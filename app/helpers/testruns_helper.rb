module TestrunsHelper
    def list_cores(rev)
        cores = []
        Dir.foreach(rev.builddir) do |f|
            if f =~ /^core.\d+/
                cores << f
            end
        end
        return cores
    end
end
