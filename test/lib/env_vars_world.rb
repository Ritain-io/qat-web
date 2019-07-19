module EnvVarsWorld

  def override_env key, value
    self.original_env[key] = ENV[key]

    ENV[key] = value
  end

  def reset_env!
    self.original_env.each do |key, value|
      ENV[key] = value
    end
  end

  def original_env
    @original_env ||= {}
  end
end


World EnvVarsWorld

After do |scenario|
  reset_env!
end