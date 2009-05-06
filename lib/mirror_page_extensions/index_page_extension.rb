module MirrorPageExtensions
  module IndexPageExtension

    def self.included(base)
      base.instance_eval do
        alias_method_chain :render, :mirror
      end
    end

    def render_with_mirror
      published_children = children.delete_if{|c| c.status_id != 100 }
      if !published_children.empty?
        if defined?(SiteLanguage)  && SiteLanguage.count > 0
          response.redirect "/#{params[:language]||I18n.code.to_s}#{published_children.first.url}", "302 Found"
        else
          if @redirect_url != nil
            response.redirect @redirect_url, "302 Found"
          else
            response.redirect published_children.first.url, "302 Found"
          end
        end
      else
        super
      end
    end
  end
end