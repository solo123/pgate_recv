class SendNotifyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    n = args[0]
    return unless n
    return if n.status && n.status >= 7
    unless n.notify_url =~ URI.regexp
      n.status = 7
      n.message = '非法的notify_url'
      n.save
      return
    end

    n.message = '' unless n.message
    begin
      uri = URI(n.notify_url)
      resp = Net::HTTP.post_form(uri, data: n.data)
      if resp.is_a?(Net::HTTPOK)
        n.status = 8
        n.save
      else
        n.status += 1
        n.message += "\n[#{resp.code}] #{resp.message}"
        n.save
      end
    rescue => e
      n.message += "\n" + e.message
      n.status += 1
      n.save
    end
    if n.status < 7
      wait_times = [1, 2, 5, 20, 60, 120, 600]
      SendNotifyJob.perform_in(wait_times[n.status], n)
    end
  end
end
