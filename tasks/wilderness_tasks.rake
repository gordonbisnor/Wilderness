namespace :wilderness do  
  desc "Install Wilderness"  
  task :install do  
    system "rsync -ruv vendor/plugins/wilderness/install-with-rake/ ."  
  end  
end