module ApplicationHelper
  def icon(icon_style, icon_name, size: nil, additional_classes: '')
    classes = ["fa-#{icon_style}", "fa-#{icon_name}", additional_classes]
    classes << "text-#{size}" if size
    tag.i(class: classes)
  end


  def default_meta_tags
    {
      site: 'oha-log',
      title: 'おはログ!!🌞',
      reverse: true,
      separator: '|',   #Webサイト名とページタイトルを区切るために使用されるテキスト
      description: '朝活開始時刻を手軽に記録！！カレンダーやランキングで可視化することで、毎日の継続を楽しめる朝活サポートサービスです。',
      keywords: 'カレンダー, 朝活, 今日の積み上げ, 社会人',   #キーワードを「,」区切りで設定する
      canonical: request.original_url,   #優先するurlを指定する
      noindex: ! Rails.env.production?,
      icon: [                    #favicon、apple用アイコンを指定する
        { href: image_url('header_logo1.png'), sizes: '180x180'}
      ],
      og: {
        site_name: 'oha-log',
        title: 'おはログ!!🌞',
        description: '朝活開始時刻を手軽に記録！！カレンダーやランキングで可視化することで、毎日の継続を楽しめる朝活サポートサービスです。',
        type: 'website',
        url: request.original_url,
        image: image_url('oha-log_img.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@oha_log0869',
        image: image_url('oha-log_img1.png'),
      }
    }
  end




end
