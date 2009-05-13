module TestrunsHelper
    def list_cores(rev)
        cores = []
        if Dir.exists?(rev.builddir)
            Dir.foreach(rev.builddir) do |f|
                if f =~ /^core.\d+/
                    cores << f
                end
            end
        end
        return cores
    end
end
