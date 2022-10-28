module RequestHelper
  def is_logged_in?
    # Sorcery gemもログイン時にuser_idをsession保存しているみたい
    !session[:user_id].nil?
  end

  def log_in_as(user, remember: '1')
    post togo_inu_shitsuke_hiroba_login_path, params: { session: {
      email: user.email,
      password: 'password',
      remember: remember
    }}
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
