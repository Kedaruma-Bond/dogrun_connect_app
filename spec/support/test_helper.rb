module RequestHelper
  def is_logged_in?
    # Sorcery gemもログイン時にuser_idをsession保存しているみたい
    !session[:user_id].nil?
  end

  def togo_inu_shitsuke_hiroba_log_in_as(user)
    post togo_inu_shitsuke_hiroba_login_path, params: { 
      session: {
      email: user.email,
      password: 'password',
      remember: true
      }
    }
  end
  
  def reon_log_in_as(user)
    post reon_login_path, params: { 
      session: {
      email: user.email,
      password: 'password',
      remember: true
      }
    }
  end
end

module SystemHelper
  def login_as(user)
    visit togo_inu_shitsuke_hiroba_top_path
    click_on 'ログイン'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    sleep 0.5
  end

  def logout
    click_on 'ログアウト'
    page.accept_confirm
  end
end
