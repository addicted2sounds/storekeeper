module MechanizeParser
  def capybara_register_driver
    Capybara.register_driver :mechanize do |app|
      driver = Capybara::Mechanize::Driver.new(app)
      driver.configure do |agent|
        agent.user_agent_alias = 'Mac Safari'
      end
      driver
    end
    Capybara.app = 'StoreKeeper'
  end

  def capybara_setup
    capybara_register_driver
    Capybara.configure do |config|
      config.run_server = false
      config.default_driver = :mechanize
      set_env_proxy
    end
  end

  def set_env_proxy
    return unless ENV['PROXY']
    proxy = URI.parse ENV['PROXY']
    Capybara.current_session.driver.browser.agent.set_proxy(proxy.host, proxy.port)
  end
end
