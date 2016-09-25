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
    rv.detail = request.headers.to_h.ai(html: true)
    rv.status = 0
    rv.save

    if rv.check_is_valid_notify
      notify_client(rv.kaifu_result)
    end
  end

private
  def notify_client(kaifu_result)
    kaifu_result.init_validate
    if kaifu_result.status < 7
      kaifu_result.status += 1
      kaifu_result.notify_time = Time.now
      begin
        uri = URI(kaifu_result.notify_url)
        js = {
          org_id: kaifu_result.organization_id,
          order_id: kaifu_result.org_send_seq_id,
          resp_code: kaifu_result.resp_code,
          resp_desc: kaifu_result.resp_desc,
          pay_result: kaifu_result.pay_result,
          pay_desc: kaifu_result.pay_desc,
          amount: kaifu_result.trans_amt,
          fee: kaifu_result.fee
        }
        if kaifu_result.t0_resp_code == '00'
          js[:pay_desc] += ' T0:' + kaifu_result.t0_resp_desc
        end
        resp = Net::HTTP.post_form(uri, data: js.to_json)
        if resp.is_a?(Net::HTTPOK)
          kaifu_result.status = 8
        end
      rescue => e
      end
      kaifu_result.save
    end
  end

end
