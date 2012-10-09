module ApplicationHelper
  def current_user  
    if session[:user_id]
		current_user ||= User.find(session[:user_id])
	else
		current_user = nil
		nil
	end
  end

  def nice_date d
	d.strftime("%A, %B %d, %Y")
  end

  def nice_datetime d
	d.strftime("%I:%M %p %m-%d-%Y")
  end

  def tabify list
		r = '<ul class="nav nav-tabs">'
		active = true
		list.each_pair do |li, str|
			if content_for? li
				r << "
"
				if active
					r << '<li class="active"><a data-toggle="tab" href="#'+li.to_s+'">'+str+'</a></li>'
					active = false
				else
					r << '<li><a data-toggle="tab" href="#'+li.to_s+'">'+str+'</a></li>'
				end
			end
		end
		r << '</ul>'
		r << "

"
		r << '<div class="tab-content" style="border: thin inset black; margin-top: 0px; background-color: #ccc">'
		list.each_pair do |li, str|
			if content_for? li
				if !active
					r << '<div class="tab-pane active" id="'+li.to_s+'">'
					active = true
				else
					r << '<div class="tab-pane" id="'+li.to_s+'">'
				end
				r << "
"
				r << content_for(li)
				r << "
"
				r << '</div>'
				r << "
"
			end
		end
		r << '</div>'
		r.html_safe
	end

	def twitterized_type(type)
		case type
		when :alert
			"warning"
		when :error
			"error"
		when :notice
			"info"
		when :success
			"success"
		else
			type.to_s
		end
	end

	def time_delta time
		if time < Time.now
			distance_of_time_in_words_to_now(time) + " ago"
		else
			distance_of_time_in_words_to_now(time) + " from now"
		end
	end

	def can(right,queue=nil,user=nil)
		raise 'outside of queue' if (@ticketqueue == nil && queue == nil)
		raise 'no user supplied' if (user == nil && current_user == nil)
		return nil if (@ticketqueue == nil && queue == nil)
		x = (queue || @ticketqueue).secures(user || current_user)
		return nil unless x
		return x.can right
	end

	def can? right
		can right
	end

	def payment_type_icon(type)
		r = i('star')
		case type
			when 'payment'
				r = i('envelope')
			when 'exam'
				r = i('pencil')
			when 'credit'
				r = i('gift')
			when 'debit'
				r = i('shopping-cart')
			when 'other'
				r = i('info-sign')
		end
		r
	end

	def truthy_thumb(value)
		if value=="*"
			i('star').html_safe
		elsif value
			i('thumbs-up').html_safe
		else
			i('thumbs-down').html_safe
		end
	end

	def i(c)
		('<i class="icon-' + c + '"></i>').html_safe
	end

	def markdown(text)
		sanitize(BlueCloth::new(text).to_html)
	end

	def dollars amt
		if amt >= 0
			number_to_currency amt
		else
			('<span class="neg">' + number_to_currency(amt) + '</span>').html_safe
		end
	end

	def symbol_key
	"<table class=\"table table-narrow\">
		<tr>
			<td rowspan=\"2\" width=\"10%\">Symbol Key</td>
			<td>#{ payment_type_icon 'exam' } - Exam Fee</td>
			<td>#{ payment_type_icon 'debit' } - Debit</td>
			<td>#{ payment_type_icon 'other' } - Other</td>
			<td>#{ i 'time' } - Time Conflict</td>
		</tr>
		<tr>
			<td>#{ payment_type_icon 'payment' } - Payment</td>
			<td>#{ payment_type_icon 'credit' } - Credit</td>
			<td>#{ i 'flag' } - Discounted Exam</td>
			<td>#{ i 'asterisk' } - Alternate Session</td>
		</tr>
</table>".html_safe
	end

	def select_compare name
		select_tag name, options_for_select({'>' => :gt, '>=' => :gte, '==' => :eq, '<=' => :lte, '<' => :lt}.to_a), :class => 'input-small'
	end

	def compare_symbol name
		{'>' => :gt, '>=' => :gte, '=' => :eq, '<=' => :lte, '<' => :lt}.index name
	end
end
