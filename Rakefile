require "erb"
require "rake"
require 'yaml'

DOWNLOAD_BASE='https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/generic/'
SDK_BASE="OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64"
NODES_FILE="nodes.yml"
FIRMWARE_FILE="bin/ar71xx/openwrt-15.05-ar71xx-generic-tl-wr842n-v2-squashfs-sysupgrade.bin"
PROFILE="TLWR842"
PACKAGES="ip collectd collectd-mod-ping collectd-mod-network collectd-mod-wireless uhttpd luci babeld batctl bird4-uci bird4 bird6-uci bird6 birdc4 birdc6 birdcl4 birdcl6 collectd-mod-wireless"


task :default => :generate_all
task :generate_all => :install_sdk do
  # Default Generate config for all nodes
  nodes = YAML.load_file(NODES_FILE)
  nodes.values.each {|v| generate_node v}
end

def generate_node(node_cfg)
  dir_name = "#{SDK_BASE}/files_generated"
  
  prepare_directory(dir_name)
  #Evaluate templates
  Dir.glob("#{dir_name}/**/*.erb").each do |erb_file|
    basename = erb_file.gsub '.erb',''
    process_erb(node_cfg,erb_file,basename)    
  end
  generate_firmware(node_cfg['hostname'])
  
end

def prepare_directory(dir_name)
  # Clean up
  FileUtils.rm_r dir_name if File.exists? dir_name
  
  # Prepare
  FileUtils.cp_r 'files', dir_name, :preserve => true
end

def process_erb(node,erb,base)
  @node = node
  template = ERB.new File.new(erb).read
  File.open(base, 'w') { |file| file.write(template.result) }
  FileUtils.rm erb
end

def generate_firmware(node_name)
  system("make -C #{SDK_BASE}  image PROFILE=#{PROFILE} PACKAGES='#{PACKAGES}'  FILES=./files_generated")
  FileUtils.mv "#{SDK_BASE}/#{FIRMWARE_FILE}", "bin/#{node_name}.bin"
end

task :install_sdk do 
  sdk_archive = "#{SDK_BASE}.tar.bz2"
  unless File.exists? SDK_BASE 
    system("wget #{DOWNLOAD_BASE}#{sdk_archive}") unless File.exists? sdk_archive
    system("tar xf #{sdk_archive}")
  end
end
