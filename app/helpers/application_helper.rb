module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'DogrunConnect'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def default_meta_tags
    {
      site: Rails.application.credentials.meta_tags[:app],
      charset: 'utf-8',
      description: Rails.application.credentials.meta_tags[:description],
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      og: {
        site_name: Rails.application.credentials.meta_tags[:app],
        description: Rails.application.credentials.meta_tags[:description],
        type: 'website',
        url: request.original_url,
        image: image_url('https://res.cloudinary.com/hryerpkcw/image/upload/v1661386829/ogp_ey7hpa.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: Rails.application.credentials.meta_tags[:twitter_account],
        title: page_title( "<%= yield :title %>" ),
        og: {
          title: page_title( "<%= yield :title %>" )
        },
        text: {
          title: "DogrunConnect's tweet"
        },
      },
      fb: {
        # app_id: '¥facebookのID'
      }
    }
  end
end
