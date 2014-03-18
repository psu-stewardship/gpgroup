require 'gpgme'

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
    use_keyring username
    yield
    GPGME::Engine.home_dir = nil
  end

  def use_keyring(username)
    GPGME::Engine.home_dir = keyring_path.join(username.to_s).to_s
  end

  def reset_keyrings
    FileUtils.rm_rf(keyring_path)
    FileUtils.mkpath(keyring_path)
    FileUtils.cp_r(fixtures_path.join("alice"), keyring_path.join("alice"))
    FileUtils.cp_r(fixtures_path.join("bob"), keyring_path.join("bob"))

    # Use Bob's keyring by default
    use_keyring :bob
  end

  def fixtures_path
    $root.join("spec/fixtures")
  end

  def keyring_path
    $root.join("tmp/keyrings")
  end

  def known_emails
    GPGME::Key.find(:public).map(&:email)
  end

end