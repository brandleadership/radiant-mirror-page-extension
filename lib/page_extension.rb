module PageExtension

    def self.included(base)
      base.instance_eval do
        alias_method_chain :find_by_url, :mirror
      end
    end

    def find_by_url_with_mirror(url, live = true, clean = true)
      #original radiant code
      return nil if virtual?
      url = clean_url(url) if clean
      my_url = self.url
      if (my_url == url) && (not live or published?)
        self
      elsif (url =~ /^#{Regexp.quote(my_url)}([^\/]*)/)
        slug_child = children.find_by_slug($1)
        if slug_child
          if (slug_child.class_name == "MirrorPage")
            found = slug_child.find_by_mirror_url(url, live, clean)
          else
            found = slug_child.find_by_url(url, live, clean)
          end
          return found if found
        end
        children.each do |child|
          found = child.find_by_url(url, live, clean)
          return found if found
        end
        file_not_found_types = ([FileNotFoundPage] + FileNotFoundPage.descendants)
        file_not_found_names = file_not_found_types.collect { |x| x.name }
        condition = (['class_name = ?'] * file_not_found_names.length).join(' or ')
        condition = "status_id = #{Status[:published].id} and (#{condition})" if live
        children.find(:first, :conditions => [condition] + file_not_found_names)
      end
    end

    def find_by_mirror_url(url, live = true, clean = true, mirror_url = nil, mirror_root_url = nil)
      if (class_name == "MirrorPage")
        page = Page.find_by_id(mirror_page)
        mirror_url = self.url
        mirror_root_url = page.url
      else
        page = self
      end
      my_url = self.url
      my_url[mirror_root_url]  = mirror_url if self.class_name != "MirrorPage"
      if (my_url == url) && (not live or published?)
        page
      elsif (url =~ /^#{Regexp.quote(my_url)}([^\/]*)/)
        slug_child = page.children.find_by_slug($1)
        slug_child.find_by_mirror_url(url, live, clean, mirror_url, mirror_root_url)
      end 
    end
end