Pod::Spec.new do |s|

  s.name = 'FHJSONObject'
  s.version = '1.0'
  s.description = <<-DESC
        FHJSONObject ,json数据解析
          DESC
 
  s.license = 'MIT'
  s.summary = 'FHJSONObject'
  s.homepage = 'https://github.com/shenfh/FHJSONObject.git'
  s.authors = { 'shenfh' => '' }
  s.source = { :git => 'https://github.com/shenfh/FHJSONObject.git', :branch => 'master' }
  s.requires_arc = true
  s.ios.deployment_target = '7.0'

  
  s.subspec 'Source' do |ss|
    ss.source_files = 'FHJSONObject/JSONObject/*.{h,m}'
    ss.public_header_files = 'FHJSONObject/JSONObject/*.{h}'      
  end 
   
end