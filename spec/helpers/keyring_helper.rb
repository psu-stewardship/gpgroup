module KeyringHelper

  def as_alice(&block)
    as_user :alice do
      yield
    end
  end

  def as_bob(&block)
    as_user :bob do
      yield
    end
  end

  def as_user(username, &block)
    old_home_dir = GPGME::Engine.home_dir
    GPGME::Engine.home_dir = $root.join("spec/fixtures/#{username}").to_s
    yield
    GPGME::Engine.home_dir = old_home_dir
  end

end