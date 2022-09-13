module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'DogrunConnect'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def send_notification_mail(staffs)
    @staffs = staffs
    unless @staffs.blank? then
      n = 0
      @dogrun_place = DogrunPlace.find(@staffs[0].dogrun_place_id)
      @staffs.size.times do
        PostMailer.post_notification(@staffs[n], @dogrun_place).deliver_now
        n += 1
      end
    end
    return
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
        image: image_url('https://res.cloudinary.com/hryerpkcw/image/upload/f_auto,q_auto/v1661386829/ogp_ey7hpa.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: Rails.application.credentials.meta_tags[:twitter_account],
        title: page_title( "DogrunConnect" ),
        og: {
          title: page_title( "DogrunConnect" )
        },
        text: {
          title: "Connect to Dogrun with fun"
        },
      },
      fb: {
        app_id: Rails.application.credentials.meta_tags[:facebook_id]
      }
    }
  end
end
