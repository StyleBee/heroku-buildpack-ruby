class LanguagePack::Ruby < LanguagePack::Base
  TRUTHY_STRING = /^(true|on|yes|1)$/

  alias_method :orig_compile, :compile
  def compile
    # Recompile all gems if 'requested' via environment variable
    # The user-env-compile labs feature must be enabled for this to work
    # See https://devcenter.heroku.com/articles/labs-user-env-compile
    if ENV['RECOMPILE_ALL_GEMS'] =~ TRUTHY_STRING
      puts  "CLEARING BUNDLER CACHE TO FORCE GEM RECOMPILE"
      cache_clear("vendor/bundle")
    end

    orig_compile
  end
end
