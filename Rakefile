require "erb"
require "rake"
require 'yaml'

OPENWRT_VERSION="23.05.4"
PLATFORM="x86"
PLATFORM_TYPE="64"
DOWNLOAD_BASE="https://downloads.openwrt.org/releases/#{OPENWRT_VERSION}/targets/#{PLATFORM}/#{PLATFORM_TYPE}/"
SDK_BASE="openwrt-imagebuilder-#{OPENWRT_VERSION}-#{PLATFORM}-#{PLATFORM_TYPE}.Linux-x86_64"

task :default => :generate_all
task :generate_all => :install_sdk do

  if (! (File.exists? 'secrets.yml'))
    raise "\n \t >>> Please decrypt secrets.yml.gpg first \n\n\n"
  end
  secrets = YAML.load_file("secrets.yml")

  # Default Generate config for all nodes
  nodes = YAML.load_file("nodes.yml")
  nodes.values.each {|v| generate_node v,secrets}
end

def generate_node(node_cfg,secrets)
  dir_name = "#{SDK_BASE}/files_generated"
  
  prepare_directory(dir_name)
  #Evaluate templates
  Dir.glob("#{dir_name}/**/*.erb").each do |erb_file|
    basename = erb_file.gsub '.erb',''
    process_erb(node_cfg,erb_file,basename,secrets)    
  end
  generate_firmware(node_cfg['hostname'], node_cfg['profile'], node_cfg['packages'])
  
end

def prepare_directory(dir_name)
  # Clean up
  FileUtils.rm_r dir_name if File.exists? dir_name
  
  # Prepare
  FileUtils.cp_r 'files', dir_name, :preserve => true
end

def process_erb(node,erb,base,secrets)
  @node = node
  @secrets = secrets
  template = ERB.new File.new(erb).read
  File.open(base, 'w') { |file| file.write(template.result) }
  FileUtils.rm erb
end

def generate_firmware(node_name,profile,packages)
  FileUtils.rm_r "#{SDK_BASE}/bin/" if File.exists?  "#{SDK_BASE}/bin/"
  puts "Exec: make -C '#{SDK_BASE}' image PROFILE=#{profile} PACKAGES='#{packages}'  FILES=./files_generated"
  system("make -C '#{SDK_BASE}' image PROFILE=#{profile} PACKAGES='#{packages}'  FILES=./files_generated")

  FileUtils.mv(
    "#{SDK_BASE}/bin/targets/#{PLATFORM}/#{PLATFORM_TYPE}/openwrt-#{OPENWRT_VERSION}-#{PLATFORM}-#{PLATFORM_TYPE}-#{profile}-squashfs-sysupgrade.bin",
    "bin/#{node_name}-sysupgrade.bin")
  FileUtils.mv(
    "#{SDK_BASE}/bin/targets/#{PLATFORM}/#{PLATFORM_TYPE}/openwrt-#{OPENWRT_VERSION}-#{PLATFORM}-#{PLATFORM_TYPE}-#{profile}-squashfs-factory.bin",
    "bin/#{node_name}-factory.bin")
end

task :install_sdk do 
  sdk_archive = "#{SDK_BASE}.tar.xz"
  unless File.exists? SDK_BASE 
    system("wget #{DOWNLOAD_BASE}#{sdk_archive}") unless File.exists? sdk_archive
    system("tar xf #{sdk_archive}")
  end
end
