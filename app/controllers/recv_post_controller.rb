class RecvPostController < ApplicationController
  def notify_fun
    save_to_db(request, 'notify')
    render plain: 'true'
  end
  def callback_fun
    save_to_db(request, 'callback')
    render plain: 'true'
  end
  def save_to_db(request, method)
    header_text = request.headers["REQUEST_METHOD"] + ' '
      + request.headers["HTTP_HOST"] + request.headers["PATH_INFO"] + " "
      + request.headers["SERVER_PROTOCOL"].to_s + "\n"
      + "User-Agent: " + request.headers["User-Agent"].to_s + "\n"
      + "Accept: " + request.headers["Accept"] + "\n"
      + "Content-Type: " + request.headers['Content-Type'] + "\n"
      + "Content-Length: " + request.headers['Content-Length'] + "\n"

    rv = RecvPost.new
    rv.method = method
    rv.remote_host = request.headers['remote-addr']
    rv.header = header_text
    rv.params = request.params.to_s
    rv.data = params['data']
    rv.detail = request.headers.to_h.ai(html: true)
    rv.status = 0
    rv.save

    n = Biz::TransBiz.create_notify(rv)
    SendNotifyJob.perform_async(n) if n
  end


end
