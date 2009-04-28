namespace :radiant do
  namespace :extensions do
    namespace :mirror_page do
      
      desc "Runs the migration of the Mirror Page extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PageMirrorExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PageMirrorExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Mirror Page to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from MirrorPageExtension"
        Dir[PageMirrorExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PageMirrorExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
