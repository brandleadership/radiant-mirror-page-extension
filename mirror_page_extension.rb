# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MirrorPageExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/page_mirror"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :page_mirror
  #   end
  # end
  
  def activate
    # admin.tabs.add "Page Mirror", "/admin/page_mirror", :after => "Layouts", :visibility => [:all]
    admin.pages.edit.add :extended_metadata, 'mirror_page'
    Page.send :include, MirrorPageExtensions::PageExtension
    IndexPage.send :include, MirrorPageExtensions::IndexPageExtension
  end
  
  def deactivate
    # admin.tabs.remove "Page Mirror"
  end
  
end
