describe 'expert review' do
  ###
  # Please do not share this file with other teams.
  # Please follow the TDD process as much as you can.
  # Use factories to create necessary DB records.
  # Please avoid duplicated code as much as you can by moving the code to before(:each) block or separated methods.
  # RSpec feature tests examples: spec/features/airbrake_expection_errors_feature_tests_spec.rb and spec/features/peer_review_spec.rb
  # If your tests need to switch to different users frequently,
  # please use stub_current_user(user, user.role.name, user.role) each time to stub login behavior.
  ###

  before(:each) do
    create(:instructor)
    create_list(:participant, 3)
    create(:topic, topic_name: "TestTopic")
    create(:deadline_type, name: "submission")
    create(:deadline_type, name: "review")
    create(:deadline_type, name: "metareview")
    create(:deadline_type, name: "drop_topic")
    create(:deadline_type, name: "signup")
    create(:deadline_type, name: "team_formation")
    create(:deadline_type, name: "calibration")
    create(:deadline_right)
    create(:deadline_right, name: 'Late')
    create(:deadline_right, name: 'OK')
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: "submission").first, due_at: DateTime.now.in_time_zone + 1.day)
    create(:assignment, name: "test")
    create(:topic)
    create(:topic, topic_name: "TestReview")
    create(:team_user, user: User.where(role_id: 2).first)
    create(:team_user, user: User.where(role_id: 2).second)
    create(:assignment_team)
    create(:team_user, user: User.where(role_id: 2).third, team: AssignmentTeam.second)
    create(:signed_up_team)
    create(:signed_up_team, team_id: 2, topic: SignUpTopic.second)
    create(:assignment_questionnaire)
    create(:question)
    create(:assignment_node)


  end

  context 'in assignments#edit page' do
    it 'has a checkbox with title \'Calibration for training?\' on \'General\' tab' do
      assignment = Assignment.where(name: "test").first
      instructor = User.find_by(name: "instructor6")
      login_as("instructor6")
      stub_current_user(instructor, instructor.role.name, instructor.role)
      visit "/assignments/#{assignment.id}/edit"
      click_link 'General'
      expect(page).to have_field('Calibration for training?')
    end
    context 'when clicking \'Calibration for training?\' checkbox and clicking \'save\' button' do
      context '\'Calibration\' due date' do
        it 'works correctly'do
          # displays a new tab named \'Calibration\' and adds a calibration due date in \'Due dates\' tab'
          assignment = Assignment.where(name: "test").first
          instructor = User.find_by(name: "instructor6")
          login_as("instructor6")
          stub_current_user(instructor, instructor.role.name, instructor.role)
          visit "/assignments/#{assignment.id}/edit"
          click_link 'General'
          expect(page).to have_field('Calibration for training?')
          page.check 'Calibration for training?'
          click_on 'Save'
          #expect(page).to have_link('Calibration')
          #click_link 'Due dates'
          #fill_in 'calibration', with: 'Date'

          # allows instructors to change and save date & time and permissions of calibration due date'

        end
      end
    end
  end

  context 'when current assignment is in calibration stage' do
    context 'calibration feature' do
      it 'works correctly' do
        login_as('student2064')
      # shows current stage of this assignment to be 'Calibration' on student_task#view page
        assignment = Assignment.where(name: "test").first
        visit "/student_task/view?id=#{assignment.id}"
        expect(assignment.current_stage_name).to eql 'Calibration'
        click_link "Others' work "
      # shows 'Calibration review 1, 2, 3...' instead of 'Review 1, 2, 3...' on student_review#list page

        expect(page).to have_content("Calibration review")
        expect(page).to have_no_content("Calibration review")
      # allows students to do calibration review and the data can be saved successfully


      # the student is able to compare the results of expert review by clicking 'show calibration results' link
        click_link "show calibration results"
      end
    end
  end

  context 'when current assignment is in review stage' do
    login_as('student2064')
    assignment = Assignment.where(name: "test").first
    it 'excludes calibration reviews from outstanding review restriction and total review restriction' do


    end
    it 'shows \'Review 1, 2, 3...\' and \'Calibration review 1, 2, 3...\' on student_review#list page' do
      visit "/student_task/list"
      expect(page).to have_content("Calibration review")
      expect(page).to have_content("Review")

    end
  end
end
