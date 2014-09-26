
require 'rake/tasklib'
require 'pp'
require 'fileutils'
require 'erb'
require 'tmpdir'

module BuildTask
  class RakeTask < ::Rake::TaskLib
    def initialize(opts)
      desc 'Build RPM package'
      task 'build' do 
        @params = opts
        
        @params[:release] = "#{(Time.now - Time.new(2010)).to_i / ( 60 * 5 )}.#{@params[:commit]}"
        
        tpl_path  = 'build/rpmspec.erb'
        spec_path = "build/tmp/#{@params[:name]}.spec"

        FileUtils.mkdir 'build/tmp' unless File.exists?('build/tmp')
          
        File.open(tpl_path) do |tpl_file|
          tpl = tpl_file.read
          spec = ERB.new(tpl).result(binding)
          File.open(spec_path,"w") do |spec_file|
            spec_file.write(spec)
          end
        end

        Dir.mktmpdir('build') do |tmp|
          FileUtils.mkdir(File.join(tmp,@params[:name]))

          Dir.entries('.').reject { |el| el =~ /^\.{1,2}$/ }.each do |entry|
            FileUtils.cp_r entry, File.join(tmp,@params[:name],entry)
          end

          @params[:exclude].each do |path|
            FileUtils.rm_r File.join(tmp,@params[:name],path)
          end

          if @params[:before].respond_to?(:call) 
            Bundler.with_clean_env do
              @params[:before].call(tmp,@params)
            end
          end

          Bundler.with_clean_env do
            tar_path = File.expand_path("~/rpmbuild/SOURCES/#{@params[:name]}-#{@params[:version]}-#{@params[:release]}.tar.bz2")

            sh "tar cjf #{tar_path} -C #{tmp} #{@params[:name]}"
            sh "rpmbuild -ba #{spec_path}"
          end

          if @params[:after].respond_to?(:call) 
            Bundler.with_clean_env do
              @params[:after].call(tmp,@params)
            end
          end
        end
      end
    end
  end
end
