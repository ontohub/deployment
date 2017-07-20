# frozen_string_literal: true

require 'open3'

def popen(environment, *command)
  Open3.popen2e(environment, *command) do |_stdin, stdout_and_err, wait_thr|
    Thread.new { stdout_and_err.each { |l| puts l } }
    wait_thr.value
  end
end
