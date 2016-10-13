class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "========TEST(#{args.to_s})========"
  end
end
