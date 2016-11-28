# frozen_string_literal: true

def mixin(path)
  load File.join('config', 'mixins', "#{path}.rb")
end
