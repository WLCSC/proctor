class StudentsController < ApplicationController
	skip_before_filter :check_for_user, :only => :self
	# GET /students
	# GET /students.json
	def index
		@students = (params[:student_ids] ? Student.find(params[:student_ids]).order("name") : Student.order("name").all )

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @students }
		end
	end

	# GET /students/1
	# GET /students/1.json
	def show
		@student = Student.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @student }
		end
	end

	# GET /students/new
	# GET /students/new.json
	def new
		@student = Student.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @student }
		end
	end

	# GET /students/1/edit
	def edit
		@student = Student.find(params[:id])
	end

	# POST /students
	# POST /students.json
	def create
		@student = Student.new(params[:student])

		respond_to do |format|
			if @student.save
				format.html { redirect_to @student, notice: 'Student was successfully created.' }
				format.json { render json: @student, status: :created, location: @student }
			else
				format.html { render action: "new" }
				format.json { render json: @student.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /students/1
	# PUT /students/1.json
	def update
		@student = Student.find(params[:id])

		respond_to do |format|
			if @student.update_attributes(params[:student])
				format.html { redirect_to @student, notice: 'Student was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @student.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /students/1
	# DELETE /students/1.json
	def destroy
		@student = Student.find(params[:id])
		@student.destroy

		respond_to do |format|
			format.html { redirect_to students_url }
			format.json { head :no_content }
		end
	end

	def import
		if params[:names]
			count = 0
			params[:names].each_line do |n|
				count += 1 if Student.create(:name => n.strip, :balance => 0)
			end	
			flash[:notice] = "Added #{count} students."
		end
	end

	def operate
		if params[:commit] == "Filter"
			f = false
			if params[:name] && !params[:name].empty?
				f = true
				@students = (@students||Student).where("name LIKE ?",'%'+params[:name]+'%')
			end

			if params[:balance] && params[:balance_comp] && !params[:balance].empty?
				f = true
				comp = sql_compare_symbol(params[:balance_comp])
				@students = (@students||Student).where("balance #{comp} ?",params[:balance])
			end

			if params[:reduced]
				f = true
				@students = (@students||Student).where(:frl => true)
			end

			#AREL conditions go above this line

			if params[:exams] && params[:exams_comp] && !params[:exams].empty?
				f = true
				comp = ruby_compare_symbol(params[:exams_comp])
				@students = (@students||Student.all).delete_if{|r| !eval("#{r.exams.length} #{comp} #{params[:exams]}")}
			end

			if params[:real] && params[:real_comp] && !params[:real].empty?
				f = true
				comp = ruby_compare_symbol(params[:exams_comp])

				@students = (@students||Student.all).delete_if{|r| !eval("#{r.exams.where(:real => true).length} #{comp} #{params[:exams]}")}
			end

			if params[:attend] && params[:attend_comp] && !params[:attend].empty?
				f = true
				comp = ruby_compare_symbol(params[:attend_comp])

				@students = (@students||Student.all).delete_if{|r| !eval("#{r.enrollments.where(:alternate => false).length} #{comp} #{params[:exams]}")}
			end

			@students = Student.all unless f

			render :index
		else
			@students = (params[:student_ids] ? Student.find(params[:student_ids]) : [Student.find(params[:student_id])])
			@redirect = false
			total = @students.length
			@messages = []
			if params[:op] == 'enroll_on' 
				enroll_count = 0
				@exam = Exam.find(params[:enroll])
				@students.each do |s|
					if Enrollment.create(:student_id => s.id, :exam_id => @exam.id, :comment => '**AUTOMATIC ENROLLMENT**', :alternate => false)
						enroll_count += 1
					end
				end
				@messages << "Enrolled #{enroll_count} students in #{@exam.name}"
			end

			if params[:op] == 'remove_on'
				enroll_count = 0
				@exam = Exam.find(params[:remove])
				@students.each do |s|
					e=Enrollment.where(:student_id => s.id, :exam_id => @exam.id)
					if e[0]
						e[0].destroy
						enroll_count += 1
					end
				end
				@messages << "Removed #{enroll_count} students from #{@exam.name}"
			end

			if params[:op] == 'schedules_on'
				@redirect = true
				@top = ''
				@bottom = ''
				render 'report/tickets'
			end

			if params[:op] == 'bill_on'
				@redirect = true
				@top = ''
				@bottom = ''
				render 'report/unpaid'
			end

			if params[:op] == 'email_on'
				@students.each do |s|
					Mailman.enroll(s.id).deliver if s.email
				end
			end

			unless @redirect
				flash[:notice] = @messages.join("<br/>").html_safe if @messages.length > 0
				redirect_to students_path 
			end
		end

	end

	def email
		@student = Student.find(params[:id])
		if @student.email
		Mailman.enroll(@student.id).deliver
		redirect_to @student, :notice => "Mail sent."
		else
			redirect_to @student, :notice => "No email address for student."
		end
	end

	def self
		redirect_to root_path, :notice => "The administrator has disabled self-enrollment." unless APP_CONFIG[:exam_self_enroll]
		redirect_to root_path, :notice => "Enrollment has been closed." if self_locked?

		@exams = Exam.all
		if params[:student_name]
			@student = Student.where(:name => params[:student_name]).first
			if !APP_CONFIG[:exam_self_review] && @student && @student.enrollments.count > 0
				redirect_to root_path, :notice => "The administrator has disabled reviewing your enrollment."
				return
			end
			if APP_CONFIG[:exam_self_create] 
				@student = Student.find_or_create_by_name(params[:student_name])
				@student.email = params[:student_email].strip
				@student.balance ||= 0
				@student.save
			else
				redirect_to root_path, :notice => "The administrator has disabled student creation"
			end

			if params[:exam]
				params[:exam_ids] ||= []
				enrolls = []
				removes = []
				Exam.all.each do |exam|
					if params[:exam_ids].include? exam.id.to_s
						enrollment = Enrollment.new(:student_id => @student.id, :exam_id => exam.id, :alternate => false)
						if enrollment.save
							enrolls << enrollment.exam.name
						else
							enrolls << "Error enrolling in #{exam.name}"
						end
					else
						if APP_CONFIG[:exam_self_remove]
							while enrollment =  @student.enrollments.where(:exam_id => exam.id).first
								removes << enrollment.exam.name 
								enrollment.destroy 
							end
						else
							removes = ["The administrator has disabled self-unenrollment."]
						end
					end
				end
				message = ""
				if enrolls.count > 0
					enrolls = enrolls.join("<br/>")
					message << "#{@student.name} enrolled in the following: <br/>"
					message << enrolls
				end
				if APP_CONFIG[:exam_self_remove] && removes.count > 0
					removes = enrolls.join("<br/>")
					message << "#{@student.name} left the following: <br/>"
					message << removes
				end
				redirect_to root_path, :notice => message.html_safe
				Mailman.enroll(@student.id).deliver if @student.email && !@student.email.empty?
			end
		else
			@student = nil
		end
	end
end
