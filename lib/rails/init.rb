require "rails/init/version"

class RailsInit
    TEMPLATE = File.expand_path "../../../templates", __FILE__

    def self.process
      system "echo", "-e", "\e[92m*** Start framgia-rails-init by Framgia convention"
      @current_project = `pwd`
      @current_project = @current_project.gsub /\n/, ""

      clear_gemfile
      clear_application_erb
      cp_file

      system "echo", "-e", "\e[92m=> Your project was successfully beautified!"
    rescue => e
      system "echo", "-e", "\e[91m#{e.message}"
      system "echo", "-e", "\e[91m(!) Make sure you're in the right place!"
    end

  private_class_method
  def self.clear_gemfile
    content = File.read @current_project + "/Gemfile"
    content = content.gsub /\#\s.*\s*/, ""
    content = content.gsub /'/, '"'
    content = content.gsub /\s*^group/, "\n\ngroup"
    content = content.gsub /\s*^\s+^gem/, "\n\ngem"
    File.open @current_project + "/Gemfile", "w" do |file|
      file.puts content
      system "echo", "-e", "\e[00m- Clear Gemfile"
    end
  end

  def self.clear_application_erb
    content = File.read @current_project + "/app/views/layouts/application.html.erb"
    content = content.gsub /'/, '"'
    File.open @current_project + "/app/views/layouts/application.html.erb", "w" do |file|
      file.puts content
      system "echo", "-e", "\e[00m- Beautified /app/views/layouts/application.html.erb"
    end
  end

  def self.cp_file
    copy_file "#{@current_project}/config/database.yml",
              "config/database.yml.example"
    copy_file "#{@current_project}/config/secrets.yml",
              "config/secrets.yml.example"

    Dir.entries("#{TEMPLATE}").select do |filename|
      if filename.length > 5
        copy_file "#{TEMPLATE}/#{filename}", filename
      end
    end
  end

  def self.copy_file a, b
    `cp #{a} #{@current_project}/#{b}`
    system "echo", "-e", "\e[00m- Copy ~> #{b}"
  end
end
