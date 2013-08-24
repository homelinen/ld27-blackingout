task :default => [:build_site]

task :build_site => [:build_script] do
    `haml index.haml > index.html`
end

task :build_script do
   `coffee -cb js/*.coffee` 
end

task :clean do
    `rm -v *.html`
    `rm -v js/*.js`
end
