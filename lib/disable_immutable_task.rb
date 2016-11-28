# frozen_string_literal: true

module Capistrano
  # Capistrano freezes RakeTasks by default, to prevent users from enhancing a
  # task at the wrong point of Capistrano's boot process.
  # We need, however, to redefine tasks on the fly, so freezing tasks must be
  # disabled:
  module ImmutableTask
    def self.extended(_task)
    end

    def enhance(*args, &block)
      super(*args, &block)
    end
  end
end
