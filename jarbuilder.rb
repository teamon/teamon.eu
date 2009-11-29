require "fileutils"

class JarBuilder
  def call(params)
    # return params.inspect
    
    Thread.new do
    
      Dir.chdir("/home/teamon/winko")
      system("git pull origin master")
      system("mvn assembly:assembly")
    
      libdir = "/home/teamon/processing-lib"
      name = "winko"
      time = Time.now.strftime("%Y%m%d%H%M")

      platforms = {
        :mac => %w(libgluegen-rt.jnilib libjogl_awt.jnilib libjogl_cg.jnilib libjogl.jnilib),
        :linux => %w(libgluegen-rt.so libjogl_awt.so libjogl_cg.so libjogl.so),
        :windows => %w(gluegen-rt.dll jogl_awt.dll jogl_cg.dll jogl.dll)
      }

      Dir.chdir("target")
      Dir.mkdir("build") unless File.exist?("build")
      Dir.mkdir("build/#{time}") unless File.exist?("build/#{time}")

      platforms.each_pair do |platform, libs|
        dirname = "build/#{time}/#{name}-#{platform}"
        Dir.mkdir(dirname) unless File.exist?(dirname)


        libs.each do |lib|
          FileUtils.cp "#{libdir}/#{lib}", "#{dirname}/#{lib}"
        end

        FileUtils.cp "winko-1.0-SNAPSHOT-jar-with-dependencies.jar", "#{dirname}/"
        Dir.chdir("build/#{time}")
        system("zip -r #{name}-#{platform}.zip #{name}-#{platform}")
        Dir.chdir("../..")
        FileUtils.rm_r(dirname)
      end
    
    end

  end
end
